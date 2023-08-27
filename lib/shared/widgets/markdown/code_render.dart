import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:highlight/highlight.dart';

class CodeRender extends StatelessWidget {
  final RenderContext renderContext;
  final List<InlineSpan> Function() buildChild;

  const CodeRender(this.renderContext, this.buildChild, {super.key});

  void copyToClipboard(BuildContext context, String content) {
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Código copiado para a área de transferência.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawContent = renderContext.tree.children;
    final rawString = rawContent[0].toString();
    final content = _sanitize(rawString.substring(1, rawString.length - 1));
    final result = highlight.parse(content, autoDetection: true);

    return Stack(children: [
      SizedBox(
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
      ),
      Align(
        alignment: AlignmentDirectional.topEnd,
        child: IconButton(
          onPressed: () => copyToClipboard(context, content),
          icon: const Icon(
            Icons.copy,
            color: Colors.white,
            size: 14,
          ),
        ),
      ),
    ]);
  }

  String _sanitize(String rawContent) {
    var content = rawContent.replaceAll('\\n', '\n');
    if (content.endsWith('\n')) {
      content = content.substring(0, content.length - 1);
    }
    return content;
  }
}
