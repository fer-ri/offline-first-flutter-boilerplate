import 'dart:convert';

import 'package:get/get.dart';
import 'package:offline_first/core/models/base_model.dart';
import 'package:offline_first/core/models/queue.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';

abstract class BaseRepository<T extends BaseModel> {
  final Database db = Get.find<Database>();

  String get table;

  Future<bool> exists(Transaction txn, String value) async {
    List<Map<String, dynamic>> query = await txn.query(
      table,
      columns: ['COUNT(*)'],
      where: 'uuid = ?',
      whereArgs: [value],
    );

    return firstIntValue(query) == 1;
  }

  Future update(Transaction txn, T model) async {
    await txn.update(
      table,
      model.toMap(),
      where: 'uuid = ?',
      whereArgs: [model.uuid],
    );

    await queue(txn, 'update', model);
  }

  Future insert(Transaction txn, T model) async {
    await txn.insert(
      table,
      model.toMap(),
    );

    await queue(txn, 'insert', model);
  }

  Future<void> upsert(T model) async {
    await db.transaction((txn) async {
      if (await exists(txn, model.uuid)) {
        await update(txn, model);
      } else {
        await insert(txn, model);
      }
    });
  }

  Future<void> delete(T model) async {
    await db.transaction((txn) async {
      await txn.delete(
        table,
        where: 'uuid = ?',
        whereArgs: [model.uuid],
      );

      await queue(txn, 'delete', model);
    });
  }

  Future<int> count() async {
    List<Map<String, dynamic>> query = await db.query(
      table,
      columns: ['COUNT(*)'],
    );

    return firstIntValue(query);
  }

  Future<Queue> queue(
    Transaction txn,
    String operation,
    T model,
  ) async {
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
      docTable: table,
      operation: operation,
      data: data,
      isLocal: true,
    );

    await txn.insert('queues', queue.toMap());

    return queue;
  }
}
