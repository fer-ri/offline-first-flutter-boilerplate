import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_first/app.dart';
import 'package:offline_first/core/services/db_service.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync<Database>(
    () async => await DbService().instance,
    permanent: true,
  );

  return runApp(App());
}
