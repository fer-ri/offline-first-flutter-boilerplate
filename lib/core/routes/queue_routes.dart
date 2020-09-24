import 'package:get/get.dart';
import 'package:offline_first/core/controllers/queues/queue_controller.dart';
import 'package:offline_first/core/repositories/queue_repository.dart';
import 'package:offline_first/core/routes/constant_routes.dart';
import 'package:offline_first/ui/screens/queues/queue_screen.dart';

List<GetPage> queueRoutes = [
  GetPage(
    name: ConstantRoutes.queues,
    page: () => QueueScreen(),
    binding: BindingsBuilder(() {
      Get.lazyPut<QueueRepository>(() => QueueRepository());
      Get.lazyPut<QueueController>(() => QueueController());
    }),
  ),
];
