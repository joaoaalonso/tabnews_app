import 'package:flutter/material.dart';
import 'package:markdown_widget/config/highlight_themes.dart' as theme;
import 'package:tabnews_app/extensions/dark_mode.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tabnews_app/shared/utils/open_link.dart';
import 'package:tabnews_app/shared/widgets/image_viewer.dart';

class Markdown extends StatelessWidget {
  final String body;
  final useNewVersion = true;

  const Markdown({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final content = body
        .replaceAll('\t', '   ')
        .replaceAll('\n\n', '\n${String.fromCharCode(0x00A0)}\n');

    return Column(
      children: MarkdownGenerator(
        data: content,
        childMargin: const EdgeInsets.symmetric(vertical: 4),
        styleConfig: StyleConfig(
          markdownTheme: context.isDarkMode
              ? MarkdownTheme.darkTheme
              : MarkdownTheme.lightTheme,
          imgBuilder: (url, attributes) => ImageViewer(uri: Uri.parse(url)),
          pConfig: PConfig(
            onLinkTap: (url) {
              openUrl(context, url);
            },
          ),
          titleConfig: TitleConfig(
            h1: const TextStyle(fontSize: 24),
            h2: const TextStyle(fontSize: 22),
            h3: const TextStyle(fontSize: 20),
            h4: const TextStyle(fontSize: 18),
            h5: const TextStyle(fontSize: 16),
            h6: const TextStyle(fontSize: 14),
            commonStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
          codeConfig: CodeConfig(
            codeStyle: TextStyle(
              backgroundColor: Colors.grey[context.isDarkMode ? 700 : 300],
            ),
          ),
          preConfig: PreConfig(
            autoDetectionLanguage: true,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[context.isDarkMode ? 800 : 300],
            ),
            theme:
                context.isDarkMode ? theme.a11yDarkTheme : theme.a11yLightTheme,
          ),
        ),
      ).widgets!,
    );
  }
}
