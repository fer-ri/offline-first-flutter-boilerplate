import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:offline_first/core/models/models.dart';
import 'package:offline_first/core/repositories/repositories.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';

class SyncService {
  final Dio dio;
  final Database db;
  final AndroidDeviceInfo device;
  final QueueRepository repository;

  SyncService({this.dio, this.db, this.device, this.repository});

  Future<void> registerDevice() async {
    try {
      await dio.post(
        '/devices',
        data: <String, dynamic>{
          'deviceUuid': device.androidId,
          'deviceToken': await FirebaseMessaging().getToken(),
          'deviceModel': device.model,
        }
      );
    } on DioError catch (e) {
      print(e.response.data);

      rethrow;
    } catch (e) {
      print(e);

      rethrow;
    }
  }

  Future<void> push() async {
    try {
      List<Queue> queues = await repository.availableForPush();

      if (queues.isEmpty) {
        print('Queue is empty');

        return;
      }

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

      await repository.markAsSynced(queues);
    } on DioError catch (e) {
      print(e.response.data);

      rethrow;
    } catch (e) {
      print(e);

      rethrow;
    }
  }

  Future<void> pull() async {
    try {
      String lastCreatedAt = await repository.lastCreatedAt(device.androidId);

      Response response = await dio.post(
        '/sync/pull',
        data: <String, dynamic>{
          'deviceUuid': device.androidId,
          'deviceModel': device.model,
          'lastCreatedAt': lastCreatedAt,
        },
      );

      _handlePullResponse(response);
    } on DioError catch (e) {
      print(e.response.data);

      rethrow;
    } catch (e) {
      print(e);

      rethrow;
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


  Future<Queue> pushQueue(String operation, BaseModel model) async {
    String data;

    switch (operation) {
      case 'delete':
        break;

      default:
        data = jsonEncode(model.toMap());
        break;
    }

    Queue queue = Queue(
      docUuid: model.uuid,
      docTable: model.table,
      operation: operation,
      data: data,
      deviceUuid: device.androidId,
      deviceModel: device.model,
    );

    await repository.upsert(queue);

    return queue;
  }

  Future<Response> _post(String url, Map<String, dynamic> data) async {
    Response response = await dio.post(
      url,
      data: data,
    );

    return response;
  }
}

class SyncOperation {
  static const String INSERT = 'insert';
  static const String UPDATE = 'update';
  static const String DELETE = 'delete';
}
