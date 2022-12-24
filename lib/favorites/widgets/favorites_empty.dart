import 'package:flutter/material.dart';

class FavoritesEmpty extends StatelessWidget {
  const FavoritesEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Nenhuma publicação favoritada"),
    );
  }
}
