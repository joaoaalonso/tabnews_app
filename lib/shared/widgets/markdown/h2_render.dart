import 'package:flutter/material.dart';
import 'package:flutter_html/html_parser.dart';

class H2Render extends StatelessWidget {
  final RenderContext renderContext;
  final List<InlineSpan> Function() buildChild;

  const H2Render(this.renderContext, this.buildChild, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xDDDDDDDD)),
        ),
      ),
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
      return Text(
        content,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }
}
