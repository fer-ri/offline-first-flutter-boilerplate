import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:offline_first/core/controllers/base_controller.dart';
import 'package:offline_first/core/models/models.dart';
import 'package:offline_first/core/repositories/repositories.dart';
import 'package:offline_first/core/services/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';

class HomeController extends BaseController {
  Dio dio = Get.find();
  AndroidDeviceInfo device = Get.find();
  Database db = Get.find();
  QueueRepository _queueRepository = Get.find();

  SyncService _syncService = Get.find();

  Future<void> syncFromLocalOneOff() async {
    // setBusy();

    // Workmanager.registerOneOffTask(
    //   'syncFromLocalOneOff',
    //   'syncFromLocalOneOff',
    //   initialDelay: Duration(seconds: 1),
    //   existingWorkPolicy: ExistingWorkPolicy.keep,
    //   constraints: Constraints(
    //     networkType: NetworkType.connected,
    //   ),
    // );

    // setBusy(false);
  }

  Future<void> syncPush() async {
    List<Queue> queues = await _queueRepository.availableForPush();

    if (queues.isEmpty) {
      print('Queues is empty');

      return;
    }

    try {
      await dio.post(
        '/sync/push',
        data: <String, dynamic>{
          'queues': queues.map((e) {
            Map<String, dynamic> map = e.toMap();

            map['device_uuid'] = device.androidId;
            map['device_model'] = device.model;

            return map;
          }).toList(),
        },
      );

      await _queueRepository.markAsSynced(queues);

      return Future.value(true);
    } on DioError catch (e) {
      // print(e.request.data);
      print(e.response.data);
      return Future.value(false);
    } catch (e) {
      print(e);
    }
  }

  Future<void> syncPull() async {
    try {
      String lastCreatedAt =
          await _queueRepository.lastCreatedAt(device.androidId);

      Response response = await dio.post(
        '/sync/pull',
        data: <String, dynamic>{
          'deviceUuid': device.androidId,
          'deviceModel': device.model,
          'lastCreatedAt': lastCreatedAt,
        },
      );

      _handlePullResponse(response);

      return Future.value(true);
    } on DioError catch (e) {
      print(e.response.data);

      return Future.value(false);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _handlePullResponse(Response response) async {
    List data = response.data['data'];

    if (data == null) {
      throw Exception('Invalid response data map');
    }

    List<Queue> queues = data.map((e) => Queue.fromMap(e)).toList();

    if (queues.length == 0) {
      print('Queues is empty');

      return;
    }

    await db.transaction((txn) async {
      String now = DateTime.now().toUtc().toString();

      queues.forEach((item) async {
        List<Map<String, dynamic>> query = await txn.query(
          'queues',
          columns: ['COUNT(*)'],
          where: 'uuid = ?',
          whereArgs: [item.uuid],
        );

        if (firstIntValue(query) == 1) {
          return;
        }

        await txn.insert(
          'queues',
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );

        switch (item.operation) {
          case 'insert':
          case 'update':
            Post post = Post.fromMap(jsonDecode(item.data));

            await txn.insert(
              'posts',
              post.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );

            await txn.update('queues', {'syncedAt': now});
            break;

          case 'delete':
            await txn.delete(
              'posts',
              where: 'uuid = ?',
              whereArgs: [item.docUuid],
            );

            await txn.update('queues', {'syncedAt': now});
            break;
        }
      });
    });

    Map<String, dynamic> links = response.data['links'];

    if (links['next'] != null) {
      Response response = await dio.post(
        links['next'],
        data: <String, dynamic>{
          'deviceUuid': device.androidId,
          'deviceModel': device.model,
        },
      );

      await _handlePullResponse(response);
    }
  }

  Future<List<Post>> postAsDbModel() async {
    List<Post> posts = await Post().get();

    print(posts);

    return posts;
  }
}
