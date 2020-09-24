import 'package:offline_first/core/models/base_model.dart';

class Queue extends BaseModel {
  final String docUuid;
  final String docTable;
  final String operation;
  final String data;
  final bool isLocal;
  final String createdAt;
  final String syncedAt;

  Queue({
    String uuid,
    this.docUuid,
    this.docTable,
    this.operation,
    this.data,
    this.isLocal,
    createdAt,
    this.syncedAt,
  })  : createdAt = createdAt ?? BaseModel.now,
        super(uuid);

  @override
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'docUuid': docUuid,
      'docTable': docTable,
      'operation': operation,
      'data': data,
      'isLocal': isLocal ? 1 : 0,
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
      isLocal: map['isLocal'] == 1,
      createdAt: map['createdAt'],
      syncedAt: map['syncedAt'],
    );
  }

  @override
  String toString() {
    return 'uuid: $uuid, docUuid: $docUuid, docTable: $docTable, isLocal: $isLocal, '
        'operation: $operation, syncedAt: $syncedAt';
  }
}
