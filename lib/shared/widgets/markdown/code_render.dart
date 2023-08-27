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
    final content = rawString.substring(1, rawString.length - 1);

    final result = highlight.parse(content, autoDetection: true);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: HighlightView(
          content.replaceAll('\\n', '\n'),
          language: result.language ?? 'dart',
          padding: const EdgeInsets.only(
            top: 18,
            left: 18,
            right: 18,
            bottom: 0,
          ),
          theme: atomOneDarkTheme,
        ),
      ),
    );
  }
}
