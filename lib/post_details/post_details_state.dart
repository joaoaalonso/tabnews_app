import 'package:tabnews_app/shared/models/post.dart';

abstract class PostDetailsState {}

class LoadingPostDetailsState extends PostDetailsState {}

class SuccessPostDetailsState extends PostDetailsState {
  Post post;

  SuccessPostDetailsState({required this.post});
}

class FailurePostDetailsState extends PostDetailsState {}
