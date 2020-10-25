import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:offline_first/core/models/base_model.dart';
import 'package:sqflite/sqflite.dart';

class Post extends BaseModel {
  final String title;
  final String publishedAt;

  Post({
    String uuid,
    this.title,
    String publishedAt,
  })  : publishedAt = publishedAt ?? DateTime.now().toUtc().toString(),
        super(uuid);

  @override
  String get table => 'posts';

  Database get db => Get.find<Database>();

  Future<List<Post>> get() async {
    List<Map<String, dynamic>> lists = await db.query(table);

    return lists.map((e) => Post.fromMap(e)).toList();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'title': title,
      'publishedAt': publishedAt,
    };
  }

  Post copyWith({
    String title,
    String publishedAt,
  }) {
    return Post(
      uuid: this.uuid,
      title: title ?? this.title,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

  @override
  String toString() {
    return 'uuid: $uuid, title: $title, publishedat: $publishedAt';
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return Post(
      uuid: map['uuid'],
      title: map['title'],
      publishedAt: map['publishedAt'],
    );
  }
}
