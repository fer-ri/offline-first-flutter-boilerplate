import 'package:uuid/uuid.dart';

abstract class BaseModel {
  final String uuid;

  BaseModel(uuid) : uuid = uuid ?? Uuid().v4();

  Map<String, dynamic> toMap();

  static String get now => DateTime.now().toUtc().toString();
}
