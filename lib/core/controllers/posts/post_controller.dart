import 'package:get/get.dart';
import 'package:offline_first/core/controllers/base_controller.dart';
import 'package:offline_first/core/models/post.dart';
import 'package:offline_first/core/repositories/post_repository.dart';

class PostController extends BaseController {
  PostRepository _postRepository = Get.find();

  final RxList<Post> posts = RxList<Post>([]);

  @override
  void onReady() async {
    super.onReady();

    refreshPost();
  }

  Future<void> refreshPost() async {
    posts.assignAll(await _postRepository.all());
  }

  Future<void> removePost(Post post) async {
    posts.remove(post);

    await _postRepository.delete(post);
  }
}