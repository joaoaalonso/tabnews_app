import 'package:flutter/material.dart';
import 'package:tabnews_app/shared/models/post.dart';
import 'package:tabnews_app/shared/repositories/favorites_repository.dart';

class FavoritesButton extends StatefulWidget {
  final Post post;

  const FavoritesButton({Key? key, required this.post}) : super(key: key);

  @override
  State<FavoritesButton> createState() => _FavoritesButtonState();
}

class _FavoritesButtonState extends State<FavoritesButton> {
  final FavoritesRepository _repository = FavoritesRepository();

  bool? postIsFavorite;

  @override
  void initState() {
    super.initState();
    _repository.isPostFavorite(widget.post).then((isFavorite) {
      setState(() {
        postIsFavorite = isFavorite;
      });
    });
  }

  void add() {
    setState(() => postIsFavorite = true);
    try {
      _repository.addFavorite(widget.post);
    } catch (e) {
      setState(() => postIsFavorite = false);
    }
  }

  void remove() {
    setState(() => postIsFavorite = false);
    try {
      _repository.removeFavorite(widget.post);
    } catch (e) {
      setState(() => postIsFavorite = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (postIsFavorite == null) return const SizedBox();

    return IconButton(
      onPressed: () => postIsFavorite! ? remove() : add(),
      icon: postIsFavorite!
          ? const Icon(Icons.favorite_sharp)
          : const Icon(Icons.favorite_border),
    );
  }
}
