import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_first/core/routes/routes.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        ...postRoutes,
      ],
      initialRoute: ConstantRoutes.posts,
    );
  }
}
