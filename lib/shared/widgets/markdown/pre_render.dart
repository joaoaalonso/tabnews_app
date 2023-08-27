import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';

class PreRender extends StatelessWidget {
  final RenderContext renderContext;
  final List<InlineSpan> Function() buildChild;

  const PreRender(this.renderContext, this.buildChild, {super.key});

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
    final language = rawContent[0].attributes['class']?.split('-')[1];
    final text = _sanitize(rawContent[0].children[0].toString());

    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: HighlightView(
              text,
              language: language ?? 'js',
              padding: const EdgeInsets.all(16),
              theme: atomOneDarkTheme,
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: IconButton(
            onPressed: () => copyToClipboard(context, text),
            icon: const Icon(
              Icons.copy,
              color: Colors.white,
              size: 14,
            ),
          ),
        ),
      ],
    );
  }

  String _sanitize(String rawContent) {
    var content = rawContent.replaceAll('\\n', '\n');
    content = content.substring(1, content.length - 1);
    if (content.endsWith('\n')) {
      content = content.substring(0, content.length - 1);
    }
    return content;
  }
}
