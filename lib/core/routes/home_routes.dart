import 'package:get/get.dart';
import 'package:offline_first/core/controllers/controllers.dart';
import 'package:offline_first/core/repositories/repositories.dart';
import 'package:offline_first/core/routes/constants.dart';
import 'package:offline_first/ui/screens/home/device_info_screen.dart';
import 'package:offline_first/ui/screens/home/home_screen.dart';

List<GetPage> homeRoutes = [
  GetPage(
    name: Routes.root,
    page: () => HomeScreen(),
    binding: BindingsBuilder(() {
      Get.lazyPut<QueueRepository>(() => QueueRepository());
      Get.lazyPut<HomeController>(() => HomeController());
    }),
  ),
  GetPage(
    name: Routes.deviceInfo,
    page: () => DeviceInfoScreen(),
    binding: BindingsBuilder(() {
      Get.lazyPut<DeviceInfoController>(() => DeviceInfoController());
    }),
  ),
];
