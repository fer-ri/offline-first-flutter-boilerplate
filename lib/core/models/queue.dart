import 'package:offline_first/core/models/base_model.dart';

class Queue extends BaseModel {
  final String docUuid;
  final String docTable;
  final String operation;
  final String data;
  final String deviceUuid;
  final String deviceModel;
  final String createdAt;
  final String syncedAt;

  Queue({
    String uuid,
    this.docUuid,
    this.docTable,
    this.operation,
    this.data,
    this.deviceUuid,
    this.deviceModel,
    createdAt,
    this.syncedAt,
  })  : createdAt = createdAt ?? BaseModel.now,
        super(uuid);

  @override
  String get table => 'queues';

  @override
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'docUuid': docUuid,
      'docTable': docTable,
      'operation': operation,
      'data': data,
      'deviceUuid': deviceUuid,
      'deviceModel': deviceModel,
      'createdAt': createdAt,
      'syncedAt': syncedAt,
    };
  }

  factory Queue.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return Queue(
      uuid: map['uuid'],
      docUuid: map['docUuid'],
      docTable: map['docTable'],
      operation: map['operation'],
      data: map['data'],
      deviceUuid: map['deviceUuid'],
      deviceModel: map['deviceModel'],
      createdAt: map['createdAt'],
      syncedAt: map['syncedAt'],
    );
  }

  @override
  String toString() {
    return 'uuid: $uuid, docUuid: $docUuid, docTable: $docTable, '
        'deviceUuid: $deviceUuid, deviceModel: $deviceModel'
        'operation: $operation, syncedAt: $syncedAt';
  }
}
