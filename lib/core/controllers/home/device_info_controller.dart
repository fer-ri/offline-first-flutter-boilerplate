import 'package:device_info/device_info.dart';
import 'package:get/get.dart';
import 'package:offline_first/core/controllers/base_controller.dart';

class DeviceInfoController extends BaseController {
  final Rx<AndroidDeviceInfo> _device = Rx<AndroidDeviceInfo>();

  AndroidDeviceInfo get device => _device.value;

  @override
  void onReady() async {
    super.onReady();

    _device.value = await DeviceInfoPlugin().androidInfo;
  }
}

extension Extra on AndroidDeviceInfo {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'version.securityPatch': this.version.securityPatch,
      'version.sdkInt': this.version.sdkInt,
      'version.release': this.version.release,
      'version.previewSdkInt': this.version.previewSdkInt,
      'version.incremental': this.version.incremental,
      'version.codename': this.version.codename,
      'version.baseOS': this.version.baseOS,
      'board': this.board,
      'bootloader': this.bootloader,
      'brand': this.brand,
      'device': this.device,
      'display': this.display,
      'fingerprint': this.fingerprint,
      'hardware': this.hardware,
      'host': this.host,
      'id': this.id,
      'manufacturer': this.manufacturer,
      'model': this.model,
      'product': this.product,
      'supported32BitAbis': this.supported32BitAbis,
      'supported64BitAbis': this.supported64BitAbis,
      'supportedAbis': this.supportedAbis,
      'tags': this.tags,
      'type': this.type,
      'isPhysicalDevice': this.isPhysicalDevice,
      'androidId': this.androidId,
      'systemFeatures': this.systemFeatures,
    };
  }
}