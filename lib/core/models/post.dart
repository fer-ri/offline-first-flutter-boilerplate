import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Post {
  final String uuid;
  final String title;
  final String publishedAt;

  Post({
    uuid,
    @required this.title,
    publishedAt,
  })  : uuid = uuid ?? Uuid().v4(),
        publishedAt = publishedAt ?? DateTime.now().toUtc().toString();

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

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'title': title,
      'publishedAt': publishedAt,
    };
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
