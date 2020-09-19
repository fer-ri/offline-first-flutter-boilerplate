import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseRepository {
  final Database db = Get.find<Database>();

  String get table;
}