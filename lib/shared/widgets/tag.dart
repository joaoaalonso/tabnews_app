import 'package:flutter/material.dart';
import 'package:tabnews_app/extensions/dark_mode.dart';

enum TagType {
  blue,
  green,
}

class Tag extends StatelessWidget {
  final String label;
  final TagType type;

  const Tag({super.key, required this.label, this.type = TagType.blue});

  Color getBackgroundColor() {
    if (type == TagType.green) {
      return const Color.fromARGB(255, 218, 251, 225);
    } else {
      return const Color.fromARGB(255, 221, 244, 255);
    }
  }

  Color getTextColor() {
    if (type == TagType.green) {
      return const Color.fromARGB(255, 86, 155, 111);
    } else {
      return const Color.fromARGB(255, 114, 152, 236);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = {
      'dark': {
        TagType.green: {
          'background': const Color.fromARGB(255, 86, 155, 111),
          'text': const Color.fromARGB(255, 218, 251, 225),
        },
        TagType.blue: {
          'background': const Color.fromARGB(255, 114, 152, 236),
          'text': const Color.fromARGB(255, 221, 244, 255),
        },
      },
      'light': {
        TagType.green: {
          'background': const Color.fromARGB(255, 218, 251, 225),
          'text': const Color.fromARGB(255, 86, 155, 111)
        },
        TagType.blue: {
          'background': const Color.fromARGB(255, 221, 244, 255),
          'text': const Color.fromARGB(255, 114, 152, 236)
        },
      },
    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      decoration: BoxDecoration(
        color:
            colors[context.isDarkMode ? 'dark' : 'light']![type]!['background'],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colors[context.isDarkMode ? 'dark' : 'light']![type]!['text'],
          fontSize: 12,
        ),
      ),
    );
  }
}
