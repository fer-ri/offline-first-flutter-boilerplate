import 'package:get/get.dart';
import 'package:offline_first/core/controllers/base_controller.dart';
import 'package:offline_first/core/controllers/mixins/form_mixin.dart';
import 'package:offline_first/core/models/post.dart';
import 'package:offline_first/core/repositories/post_repository.dart';

class PostFormController extends BaseController with FormMixin {
  final PostRepository _postRepository = Get.find();

  Post post;

  String get title => post == null ? 'Create Post' : 'Edit Post';

  String get buttonText => post == null ? 'Save' : 'Update';

  @override
  void onInit() {
    super.onInit();

    post = Get.arguments;
  }

  Future<void> submit() async {
    Get.focusScope.unfocus();

    if (!validateForm()) {
      return;
    }

    setBusy();

    try {
      post == null ? await _store() : await _update();

      formWasEdited = false;

      Get.back();
    } catch (e) {
      rethrow;
    } finally {
      setBusy(false);
    }
  }

  Future<void> _store() async {
    Post post = Post(
      title: getFieldValue('title'),
    );

    await _postRepository.upsert(post);
  }

  Future<void> _update() async {
    post = post.copyWith(
      title: getFieldValue('title'),
    );

    await _postRepository.upsert(post);
  }
}
