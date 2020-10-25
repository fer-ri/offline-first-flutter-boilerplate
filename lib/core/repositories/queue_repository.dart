import 'package:device_info/device_info.dart';
import 'package:get/get.dart';
import 'package:offline_first/core/models/queue.dart';
import 'package:offline_first/core/repositories/base_repository.dart';

class QueueRepository extends BaseRepository {
  AndroidDeviceInfo device = Get.find();

  @override
  String get table => 'queues';

  Future<List<Queue>> all() async {
    print('QueueRepository all');

    List<Map<String, dynamic>> query = await db.query(
      table,
      orderBy: 'createdAt DESC, syncedAt DESC',
    );

    return query.map((item) => Queue.fromMap(item)).toList();
  }

  Future<String> lastCreatedAt(String deviceUuid) async {
    List<Map<String, dynamic>> maps = await db.query(
      table,
      columns: ['createdAt'],
      where: 'uuid <> ?',
      whereArgs: [deviceUuid],
      orderBy: 'createdAt DESC',
      limit: 1,
    );

    return maps.length > 0 ? maps.first['createdAt'] : null;
  }

  Future<List<Queue>> availableForPush([int limit = 10]) async {
    // TODO Group docUuid and get latest snapshot only
    // If have another snapshot, then set syncedAt to now
    List<Map<String, dynamic>> query = await db.query(
      table,
      where: 'syncedAt IS NULL',
      orderBy: 'createdAt ASC, syncedAt ASC',
      limit: 10,
    );

    List<Queue> queues = query.map((item) => Queue.fromMap(item)).toList();

    return queues;
  }

  Future<void> markAsSynced(List<Queue> queues) async {
    if (queues.isEmpty) return;

    String now = DateTime.now().toUtc().toString();

    List<String> uuids = queues.map((i) => i.uuid).toList();

    await db.transaction((txn) async {
      await txn.update(
        table,
        <String, dynamic>{'syncedAt': now},
        where: 'uuid IN (${uuids.map((e) => '?').join(', ')})',
        whereArgs: uuids,
      );
    });
  }
}