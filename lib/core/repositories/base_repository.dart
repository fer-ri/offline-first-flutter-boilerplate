import 'package:get/get.dart';
import 'package:offline_first/core/models/base_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';

abstract class BaseRepository {
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

  Future update(Transaction txn, BaseModel model) async {
    await txn.update(
      table,
      model.toMap(),
      where: 'uuid = ?',
      whereArgs: [model.uuid],
    );
  }

  Future insert(Transaction txn, BaseModel model) async {
    await txn.insert(
      table,
      model.toMap(),
    );
  }

  Future<void> upsert(BaseModel model) async {
    await db.transaction((txn) async {
      if (await exists(txn, model.uuid)) {
        await update(txn, model);
      } else {
        await insert(txn, model);
      }
    });
  }

  Future<void> delete(BaseModel model) async {
    await db.transaction((txn) async {
      await txn.delete(
        table,
        where: 'uuid = ?',
        whereArgs: [model.uuid],
      );
    });
  }

  Future<int> count() async {
    List<Map<String, dynamic>> query = await db.query(
      table,
      columns: ['COUNT(*)'],
    );

    return firstIntValue(query);
  }
}
