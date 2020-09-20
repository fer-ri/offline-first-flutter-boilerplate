import 'package:get/get.dart';
import 'package:offline_first/core/models/base_model.dart';
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
  }

  Future insert(Transaction txn, T model) async {
    await txn.insert(
      table,
      model.toMap(),
    );
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

  Future delete(T model) async {
    await db.delete(
      table,
      where: 'uuid = ?',
      whereArgs: [model.uuid],
    );
  }

  Future<int> count() async {
    List<Map<String, dynamic>> query = await db.query(
      table,
      columns: ['COUNT(*)'],
    );

    return firstIntValue(query);
  }
}