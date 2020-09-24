import 'package:get/get.dart';
import 'package:offline_first/core/controllers/home/device_info_controller.dart';
import 'package:offline_first/core/controllers/home/home_controller.dart';
import 'package:offline_first/core/routes/constant_routes.dart';
import 'package:offline_first/ui/screens/home/device_info_screen.dart';
import 'package:offline_first/ui/screens/home/home_screen.dart';

List<GetPage> homeRoutes = [
  GetPage(
    name: ConstantRoutes.root,
    page: () => HomeScreen(),
    binding: BindingsBuilder(() {
      Get.lazyPut<HomeController>(() => HomeController());
    }),
  ),
  GetPage(
    name: ConstantRoutes.deviceInfo,
    page: () => DeviceInfoScreen(),
    binding: BindingsBuilder(() {
      Get.lazyPut<DeviceInfoController>(() => DeviceInfoController());
    }),
  ),
];
