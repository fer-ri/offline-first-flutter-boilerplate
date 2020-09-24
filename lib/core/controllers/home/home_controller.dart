import 'package:dio/dio.dart';
import 'package:offline_first/core/controllers/base_controller.dart';
import 'package:offline_first/core/models/queue.dart';
import 'package:offline_first/core/services/db_service.dart';
import 'package:sqflite/sqflite.dart';

class HomeController extends BaseController {
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

    Database db = await DbService().instance;

    List<Map<String, dynamic>> query = await db.query(
      'queues',
      where: 'syncedAt IS NULL',
      orderBy: 'createdAt DESC, syncedAt DESC',
    );

    print('query.length: ${query.length}');

    if (query.length == 0) {
      print('Queues is empty');
      return;
    }

    List<Queue> queues = query.map((item) => Queue.fromMap(item)).toList();

    // queues.forEach((queue) => print(queue));

    try {
      await Dio().post(
        'http://192.168.100.9:4000/api/sync/push',
        data: <String, dynamic>{
          'queues': queues.map((e) => e.toMap()).toList(),
        },
        options: Options(
          headers: {
            Headers.acceptHeader: 'application/json',
          }
        ),
      );

      db.transaction((txn) async {
        String now = DateTime.now().toUtc().toString();
        List<String> uuids = queues.map((i) => i.uuid).toList();

        await txn.update(
          'queues',
          <String, dynamic>{'syncedAt': now},
          where: 'uuid IN (${uuids.map((e) => '?').join(', ')})',
          whereArgs: [...uuids],
        );
      });

      return Future.value(true);
    } on DioError catch (e) {
      // print(e.request.data);
      print(e.response.data);
      return Future.value(false);
    } catch (e) {
      print(e);
    }
  }
}