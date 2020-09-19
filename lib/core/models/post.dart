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

  @override
  String toString() {
    return 'uuid: $uuid, title: $title, publishedat: $publishedAt';
  }
}
