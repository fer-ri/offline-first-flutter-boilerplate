import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_first/core/controllers/posts/post_controller.dart';
import 'package:offline_first/core/models/post.dart';
import 'package:offline_first/core/routes/constant_routes.dart';

class PostScreen extends GetView<PostController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshPost(),
        child: GetX(
          builder: (_) {
            return ListView.builder(
              itemBuilder: (context, index) {
                Post post = controller.posts.elementAt(index);

                return Dismissible(
                  key: Key(post.uuid),
                  background: Container(color: Colors.grey[200]),
                  direction: DismissDirection.endToStart, // right to left
                  onDismissed: (direction) async {
                    await controller.removePost(post);
                  },
                  child: ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.publishedAt),
                  ),
                );
              },
              itemCount: controller.posts.length,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () async {
          await Get.toNamed(ConstantRoutes.postForm);

          controller.refreshPost();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
