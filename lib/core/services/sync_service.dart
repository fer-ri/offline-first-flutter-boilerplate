import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:offline_first/core/models/models.dart';
import 'package:offline_first/core/repositories/repositories.dart';
import 'package:sqflite/sqflite.dart';

class SyncService {
  final Dio dio;
  final Database db;
  final AndroidDeviceInfo device;
  final QueueRepository repository;

  SyncService({this.dio, this.db, this.device, this.repository});

  Future<void> push() async {
    try {
      List<Queue> queues = await repository.availableForPush();

      if (queues.isEmpty) {
        print('Queue is empty');

        return;
      }

      Map<String, dynamic> data = {
        'queues': queues,
      };

      await _post('/sync/push', data);

      await repository.markAsSynced(queues);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> pull() async {}

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