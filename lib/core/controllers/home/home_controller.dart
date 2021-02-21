import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:offline_first/core/controllers/base_controller.dart';
import 'package:offline_first/core/models/models.dart';
import 'package:offline_first/core/services/services.dart';
import 'package:sqflite/sqflite.dart';

class HomeController extends BaseController {
  // Dio dio = Get.find();
  // AndroidDeviceInfo device = Get.find();
  // QueueRepository _queueRepository = Get.find();
  // Database db = Get.find();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  SyncService _syncService = Get.find();

  final RxString _token = RxString('');

  String get token => _token.value;

  @override
  Future<void> onReady() async {
    super.onReady();

    _token.value = await _firebaseMessaging.getToken();

    print('_token: ${_token.value}');
  }

  Future<void> syncFromLocalOneOff() async {
    // setBusy();

    // Workmanager.registerOneOffTask(
    //   'syncFromLocalOneOff',
    //   'syncFromLocalOneOff',
    //   initialDelay: Duration(seconds: 1),
    //   existingWorkPolicy: ExistingWorkPolicy.keep,
    //   constraints: Constraints(
    //     networkType: NetworkType.connected,
    //   ),
    // );

    // setBusy(false);
  }

  Future<void> syncPush() async {
    try {
      await _syncService.push();
    } catch (e) {
      print(e);
    }
  }

  Future<void> syncPull() async {
    try {
      await _syncService.pull();
    } catch (e) {
      print(e);
    }
  }

  Future<void> resetDb() async {
    await DbService.delete();
  }

  Future<List<Post>> postAsDbModel() async {
    List<Post> posts = await Post().get();

    print(posts);

    return posts;
  }
}
