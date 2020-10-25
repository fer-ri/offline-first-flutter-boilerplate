import 'package:offline_first/core/models/post.dart';
import 'package:offline_first/core/repositories/base_repository.dart';

class PostRepository extends BaseRepository {
  String get table => 'posts';

  Future<List<Post>> all() async {
    print('PostRepository all');

    List<Map<String, dynamic>> query = await db.query(
      table,
      orderBy: 'publishedAt DESC',
    );

    return query.map((item) => Post.fromMap(item)).toList();
  }
}
