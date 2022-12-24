import 'package:timeago/timeago.dart' as timeago;

class Post {
  final String id;
  final String slug;
  final String title;
  final String? body;
  final String ownerUsername;
  final int? commentsCount;
  final List<Post> comments;
  final int? tabcoints;
  final DateTime publishedAt;
  final bool hasParent;
  final String? sourceUrl;
  final Post? parent;
  final Post? root;

  const Post({
    required this.id,
    required this.slug,
    required this.title,
    required this.body,
    required this.ownerUsername,
    required this.comments,
    required this.publishedAt,
    required this.hasParent,
    this.commentsCount,
    this.tabcoints,
    this.sourceUrl,
    this.parent,
    this.root,
  });

  Post copyWith({
    String? id,
    String? slug,
    String? title,
    String? body,
    String? ownerUsername,
    List<Post>? comments,
    int? commentsCount,
    int? tabcoints,
    DateTime? publishedAt,
    String? sourceUrl,
    bool? hasParent,
    Post? parent,
    Post? root,
  }) {
    return Post(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      title: title ?? this.title,
      body: body ?? this.body,
      ownerUsername: ownerUsername ?? this.ownerUsername,
      comments: comments ?? this.comments,
      commentsCount: commentsCount ?? this.commentsCount,
      tabcoints: tabcoints ?? this.tabcoints,
      publishedAt: publishedAt ?? this.publishedAt,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      hasParent: hasParent ?? this.hasParent,
      parent: parent ?? this.parent,
      root: root ?? this.root,
    );
  }

  String publishedIn() {
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    return timeago.format(publishedAt, locale: 'pt_BR');
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    final List<Post> children = [];
    if (json['children'] != null) {
      children.addAll(
          (json['children'] as List).map((child) => Post.fromJson(child)));
    }
    return Post(
      id: json['id'],
      slug: json['slug'],
      title: json['title'] ?? '',
      body: json['body'],
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'])
          : DateTime.now(),
      ownerUsername: json['owner_username'],
      commentsCount: json['children_deep_count'],
      comments: children,
      tabcoints: json['tabcoins'],
      sourceUrl: json['source_url'],
      hasParent: json['parent_id'] != null,
    );
  }
}
