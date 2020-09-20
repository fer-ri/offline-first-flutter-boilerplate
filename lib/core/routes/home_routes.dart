import 'package:get/get.dart';
import 'package:offline_first/core/controllers/home/home_controller.dart';
import 'package:offline_first/core/routes/constant_routes.dart';
import 'package:offline_first/ui/home/home_screen.dart';

List<GetPage> homeRoutes = [
  GetPage(
    name: ConstantRoutes.root,
    page: () => HomeScreen(),
    binding: BindingsBuilder(() {
      Get.lazyPut<HomeController>(() => HomeController());
    }),
  ),
];
