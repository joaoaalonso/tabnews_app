import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:highlight/highlight.dart';

class CodeRender extends StatelessWidget {
  final RenderContext renderContext;
  final List<InlineSpan> Function() buildChild;

  const CodeRender(this.renderContext, this.buildChild, {super.key});

  @override
  Widget build(BuildContext context) {
    final rawContent = renderContext.tree.children;
    final rawString = rawContent[0].toString();
    final content = _sanitize(rawString.substring(1, rawString.length - 1));
    print(content);
    final result = highlight.parse(content, autoDetection: true);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: HighlightView(
          content.replaceAll('\\n', '\n'),
          language: result.language ?? 'dart',
          padding: const EdgeInsets.all(16),
          theme: atomOneDarkTheme,
        ),
      ),
    );
  }

  String _sanitize(String rawContent) {
    var content = rawContent.replaceAll('\\n', '\n');
    if (content.endsWith('\n')) {
      content = content.substring(0, content.length - 1);
    }
    return content;
  }
}
