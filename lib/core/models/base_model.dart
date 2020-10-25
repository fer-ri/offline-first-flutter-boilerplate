import 'package:uuid/uuid.dart';

abstract class BaseModel {
  final String uuid;

  BaseModel(uuid) : uuid = uuid ?? Uuid().v4();

  String get table;

  Map<String, dynamic> toMap();

  static String get now => DateTime.now().toUtc().toString();
}
