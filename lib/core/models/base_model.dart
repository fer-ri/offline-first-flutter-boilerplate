import 'package:uuid/uuid.dart';

abstract class BaseModel {
  final String uuid;

  BaseModel(uuid) : uuid = uuid ?? Uuid().v4();

  Map<String, dynamic> toMap();
}