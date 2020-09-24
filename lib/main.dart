import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_first/app.dart';
import 'package:offline_first/core/services/db_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    print('Task: $task, time: ${DateTime.now().toLocal()}');

    return Future.value(true);

    // Database db = await DbService().instance;
    //
    // List<Map<String, dynamic>> query = await db.query(
    //   'queues',
    //   where: 'syncedAt IS NULL',
    //   orderBy: 'createdAt DESC, syncedAt DESC',
    // );
    //
    // List<Queue> queues = query.map((item) => Queue.fromMap(item)).toList();
    //
    // queues.forEach((queue) => print(queue));
    //
    // try {
    //   Response response = await Dio().post(
    //     'http://192.168.100.9:4000/api/sync/push',
    //     data: <String, dynamic>{
    //       'queues': jsonEncode(queues.map((e) => e.toMap()).toList()),
    //     },
    //     options: Options(
    //       headers: {
    //         HttpHeaders.contentTypeHeader: 'application/json',
    //       }
    //     ),
    //   );
    //
    //   print('Status code: ${response.statusCode}');
    //   print('Response: ${response?.data}');
    //
    //   db.transaction((txn) async {
    //     String now = DateTime.now().toUtc().toString();
    //     List<String> uuids = queues.map((i) => i.uuid).toList();
    //
    //     await txn.update(
    //       'queues',
    //       <String, dynamic>{'syncedAt': now},
    //       where: 'uuid in (?)',
    //       whereArgs: [uuids],
    //     );
    //   });
    //
    //   return Future.value(true);
    // } catch (e) {
    //   print(e);
    //   return Future.value(false);
    // }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await deleteDatabase(await DbService.path);
  // ignore: deprecated_member_use
  await Sqflite.devSetDebugModeOn(true);

  await Get.putAsync<Database>(
    () async => await DbService().instance,
    permanent: true,
  );

  Workmanager.initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  // Workmanager.registerPeriodicTask(
  //   'syncFromLocal',
  //   'syncFromLocal',
  //   existingWorkPolicy: ExistingWorkPolicy.keep,
  //   constraints: Constraints(
  //     networkType: NetworkType.connected,
  //   ),
  // );

  return runApp(App());
}
