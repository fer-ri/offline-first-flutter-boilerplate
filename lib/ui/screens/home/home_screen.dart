import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_first/core/controllers/home/home_controller.dart';
import 'package:offline_first/core/routes/constants.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline First Boilerplate'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Posts'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Get.toNamed(Routes.posts);
            },
          ),
          ListTile(
            title: Text('Queue'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Get.toNamed(Routes.queues);
            },
          ),
          ListTile(
            title: Text('Device Info'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Get.toNamed(Routes.deviceInfo);
            },
          ),
          GetX(
            builder: (_) {
              return ListTile(
                title: Text('Sync Push'),
                trailing: controller.busy('syncPush')
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : SizedBox.shrink(),
                onTap: controller.busy('syncPush')
                    ? null
                    : () => controller.syncPush(),
              );
            },
          ),
          GetX(
            builder: (_) {
              return ListTile(
                title: Text('Sync Pull'),
                trailing: controller.busy('syncPull')
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : SizedBox.shrink(),
                onTap: controller.busy('syncPull')
                    ? null
                    : () => controller.syncPull(),
              );
            },
          ),
          GetX(
            builder: (_) {
              return ListTile(
                title: Text('Post as DbModel'),
                trailing: controller.isBusy
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : SizedBox.shrink(),
                onTap: controller.isBusy
                    ? null
                    : () async => await controller.postAsDbModel(),
              );
            },
          ),
          GetX(
            builder: (_) {
              return ListTile(
                title: Text('Run Worker One Off'),
                trailing: controller.isBusy
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : SizedBox.shrink(),
                onTap: controller.isBusy
                    ? null
                    : () => controller.syncFromLocalOneOff(),
              );
            },
          ),
        ],
      ),
    );
  }
}
