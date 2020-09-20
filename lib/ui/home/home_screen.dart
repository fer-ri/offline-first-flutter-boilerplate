import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_first/core/controllers/home/home_controller.dart';
import 'package:offline_first/core/routes/constant_routes.dart';

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
              Get.toNamed(ConstantRoutes.posts);
            },
          ),
          ListTile(
            title: Text('Queue'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              //
            },
          ),
        ],
      ),
    );
  }
}
