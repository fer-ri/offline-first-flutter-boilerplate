import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_first/core/controllers/home/device_info_controller.dart';

class DeviceInfoScreen extends GetView<DeviceInfoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Info'),
      ),
      body: GetX(
        builder: (_) {
          if (controller.device == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          Map<String, dynamic> device = controller.device.toMap();

          return ListView(
            padding: EdgeInsets.all(16),
            children: device.keys.map((String property) {
              return Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      property,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    child: Text(
                      '${device[property]}',
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
