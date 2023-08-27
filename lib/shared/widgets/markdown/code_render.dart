import 'package:flutter/material.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:tabnews_app/extensions/dark_mode.dart';

class CodeRender extends StatelessWidget {
  final RenderContext renderContext;
  final List<InlineSpan> Function() buildChild;

  const CodeRender(this.renderContext, this.buildChild, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[context.isDarkMode ? 700 : 300],
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: _Content(renderContext, buildChild),
    );
  }
}

class _Content extends StatelessWidget {
  final RenderContext renderContext;
  final List<InlineSpan> Function() buildChild;

  const _Content(this.renderContext, this.buildChild);

  @override
  Widget build(BuildContext context) {
    final rawContent = renderContext.tree.children;
    if (rawContent.isEmpty) {
      return const SizedBox();
    } else if (rawContent[0].children.isNotEmpty) {
      return Text.rich(
        TextSpan(
          children: buildChild(),
        ),
      );
    } else {
      final rawString = rawContent[0].toString();
      final content = rawString.substring(1, rawString.length - 1);
      return Text(content);
    }
  }
}
