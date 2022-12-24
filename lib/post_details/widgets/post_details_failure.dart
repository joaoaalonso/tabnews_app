import 'package:flutter/material.dart';
import 'package:tabnews_app/extensions/dark_mode.dart';

class PostDetailsFailure extends StatelessWidget {
  final VoidCallback onButtonPressed;

  const PostDetailsFailure({super.key, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Center(
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
      ),
    );
  }
}
