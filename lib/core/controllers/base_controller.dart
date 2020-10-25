import 'package:get/get.dart';
import 'package:offline_first/core/services/services.dart';

abstract class BaseController extends GetxController {
  final SyncService sync = Get.find();

  final RxMap<int, bool> _busy = RxMap<int, bool>({});

  bool busy(Object object) => _busy[object.hashCode] ?? false;

  bool get isBusy => busy(this);

  void setBusy([bool value = true, Object object]) {
    object ??= this;

    _busy.add(object.hashCode, value);
  }
}