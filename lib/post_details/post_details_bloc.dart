import 'dart:async';

import 'package:tabnews_app/post_details/post_details_events.dart';
import 'package:tabnews_app/post_details/post_details_state.dart';
import 'package:tabnews_app/shared/models/post.dart';
import 'package:tabnews_app/shared/repositories/post_repository.dart';

class PostDetailsBloc {
  final PostRepository _postRepository = PostRepository();

  final StreamController<PostDetailsEvent> _inputController =
      StreamController<PostDetailsEvent>();
  final StreamController<PostDetailsState> _outputController =
      StreamController<PostDetailsState>.broadcast();

  Sink<PostDetailsEvent> get input => _inputController.sink;
  Stream<PostDetailsState> get output => _outputController.stream;

  PostDetailsBloc() {
    _inputController.stream.listen(_mapEventToState);
  }

  _mapEventToState(PostDetailsEvent event) async {
    if (event is LoadPostDetailsEvent) {
      _outputController.add(LoadingPostDetailsState());
      try {
        final results = await Future.wait([
          _postRepository.fetchPost(event.username, event.slug).then((post) {
            _outputController.add(SuccessPostDetailsState(post: post));
            return post;
          }),
          _postRepository.fetchPostComments(event.username, event.slug)
        ]);
        final comments = results[1] as List<Post>;
        final post = (results[0] as Post).copyWith(comments: comments);
        _outputController.add(SuccessPostDetailsState(post: post));
      } catch (e) {
        _outputController.add(FailurePostDetailsState());
      }
    }
  }
}
