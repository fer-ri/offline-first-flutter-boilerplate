import 'package:offline_first/core/models/queue.dart';
import 'package:offline_first/core/repositories/base_repository.dart';

class QueueRepository extends BaseRepository {
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
}