abstract class PostDetailsEvent {}

class LoadPostDetailsEvent extends PostDetailsEvent {
  final String username;
  final String slug;

  LoadPostDetailsEvent({
    required this.username,
    required this.slug,
  });
}
