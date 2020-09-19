import 'package:offline_first/core/models/post.dart';
import 'package:offline_first/core/repositories/base_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';

class PostRepository extends BaseRepository {
  String get table => 'posts';

  Future<bool> _exists(Transaction txn, Post post) async {
    List<Map<String, dynamic>> query = await txn.query(
      table,
      columns: ['COUNT(*)'],
      where: 'uuid = ?',
      whereArgs: [post.uuid],
    );

    return firstIntValue(query) == 1;
  }

  Future _update(Transaction txn, Post post) async {
    await txn.update(
      table,
      post.toMap(),
      where: 'uuid = ?',
      whereArgs: [post.uuid],
    );
  }

  Future _insert(Transaction txn, Post post) async {
    await txn.insert(
      table,
      post.toMap()..['uuid'] = post.uuid,
    );
  }

  Future<void> upsert(Post post) async {
    await db.transaction((txn) async {
      if (await _exists(txn, post)) {
        await _update(txn, post);
      } else {
        await _insert(txn, post);
      }
    });
  }

  Future delete(Post post) async {
    await db.delete(
      table,
      where: 'uuid = ?',
      whereArgs: [post.uuid],
    );
  }

  Future<int> count() async {
    List<Map<String, dynamic>> query = await db.query(
      table,
      columns: ['COUNT(*)'],
    );

    return firstIntValue(query);
  }

  Future<List<Post>> all() async {
    print('PostRepository all');

    List<Map<String, dynamic>> query = await db.query(
      table,
      orderBy: 'publishedAt DESC',
    );

    return query.map((item) => Post.fromMap(item)).toList();
  }
}
