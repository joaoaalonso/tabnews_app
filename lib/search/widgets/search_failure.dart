import 'package:flutter/material.dart';
import 'package:tabnews_app/extensions/dark_mode.dart';

class SearchFailure extends StatelessWidget {
  final VoidCallback onButtonPressed;

  const SearchFailure({
    super.key,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Ocorreu um erro inesperado.'),
          ElevatedButton(
            onPressed: onButtonPressed,
            child: Text(
              "Tentar novamente",
              style: TextStyle(
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
