import 'package:get/get.dart';
import 'package:offline_first/core/controllers/base_controller.dart';
import 'package:offline_first/core/models/queue.dart';
import 'package:offline_first/core/repositories/queue_repository.dart';

class QueueController extends BaseController {
  QueueRepository _queueRepository = Get.find();

  final RxList<Queue> queues = RxList<Queue>([]);

  @override
  void onReady() {
    super.onReady();

    refreshQueue();
  }

  Future<void> refreshQueue() async {
    queues.assignAll(await _queueRepository.all());
  }
}