import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_first/core/controllers/queues/queue_controller.dart';
import 'package:offline_first/core/models/queue.dart';

class QueueScreen extends GetView<QueueController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Queue'),
      ),
      body: GetX(
        builder: (_) {
          return ListView.builder(
            itemBuilder: (context, index) {
              Queue queue = controller.queues.elementAt(index);

              return ListTile(
                title: Text('${queue.operation} / ${queue.docTable}'),
                subtitle: Text('${queue.createdAt} / ${queue.syncedAt}'),
                trailing: queue.syncedAt == null
                    ? SizedBox.shrink()
                    : Icon(Icons.check),
              );
            },
            itemCount: controller.queues.length,
          );
        },
      ),
    );
  }
}
