import 'package:get/get.dart';
import 'package:offline_first/core/controllers/posts/post_controller.dart';
import 'package:offline_first/core/controllers/posts/post_form_controller.dart';
import 'package:offline_first/core/repositories/post_repository.dart';
import 'package:offline_first/core/routes/constants.dart';
import 'package:offline_first/ui/screens/posts/post_form_screen.dart';
import 'package:offline_first/ui/screens/posts/post_screen.dart';

List<GetPage> postRoutes = [
  GetPage(
    name: Routes.posts,
    page: () => PostScreen(),
    binding: BindingsBuilder(() {
      Get.lazyPut<PostRepository>(() => PostRepository());
      Get.lazyPut<PostController>(() => PostController());
    }),
  ),
  GetPage(
    name: Routes.postForm,
    page: () => PostFormScreen(),
    binding: BindingsBuilder(() {
      Get.lazyPut<PostRepository>(() => PostRepository());
      Get.lazyPut<PostFormController>(() => PostFormController());
    }),
    fullscreenDialog: true,
  ),
];
