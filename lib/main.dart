import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_first/app.dart';
import 'package:offline_first/core/repositories/repositories.dart';
import 'package:offline_first/core/services/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workmanager/workmanager.dart';

Dio dio = Dio();

// Must be top-level function
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    print('Task: $task, time: ${DateTime.now().toLocal()}');

    return Future.value(true);
  });
}

Future<void> initDependencies() async {
  await Get.putAsync<AndroidDeviceInfo>(() async {
    return await DeviceInfoPlugin().androidInfo;
  }, permanent: true);

  await Get.putAsync<Dio>(() async {
    AndroidDeviceInfo device = Get.find();

    dio.interceptors.add(LogInterceptor());

    (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;

    dio.options.baseUrl = 'http://192.168.100.9:4000/api';

    dio.options.headers = {
      Headers.acceptHeader: 'application/json',
      'x-device-uuid': device.androidId,
      'x-device-model': device.model,
    };

    return dio;
  }, permanent: true);

  // ignore: deprecated_member_use
  await Sqflite.devSetDebugModeOn(true);

  await Get.putAsync<Database>(() async {
    return await DbService().instance;
  }, permanent: true);

  Get.put<QueueRepository>(QueueRepository(), permanent: true);

  Get.put<SyncService>(
    SyncService(
      dio: Get.find(),
      db: Get.find(),
      device: Get.find(),
      repository: Get.find(),
    ),
    permanent: true,
  );
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];

    print('myBackgroundMessageHandler data: $data');
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];

    print('myBackgroundMessageHandler notification: $notification');
  }

  print('myBackgroundMessageHandler end');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  // await deleteDatabase(await DbService.path);

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

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    },
    onBackgroundMessage: myBackgroundMessageHandler,
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    },
  );

  _firebaseMessaging.subscribeToTopic('android');

  return runApp(App());
}
