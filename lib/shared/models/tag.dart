class Tag {
  final String name;
  final String slug;

  const Tag({
    required this.name,
    required this.slug,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'],
      slug: json['slug'],
    );
  }
}
