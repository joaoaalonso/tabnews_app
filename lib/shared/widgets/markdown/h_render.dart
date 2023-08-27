import 'package:flutter/material.dart';
import 'package:flutter_html/html_parser.dart';

class HRender extends StatelessWidget {
  final double fontSize;
  final RenderContext renderContext;
  final List<InlineSpan> Function() buildChild;

  const HRender(this.fontSize, this.renderContext, this.buildChild,
      {super.key});

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
      child: _Content(fontSize, renderContext, buildChild),
    );
  }
}

class _Content extends StatelessWidget {
  final double fontSize;
  final RenderContext renderContext;
  final List<InlineSpan> Function() buildChild;

  const _Content(this.fontSize, this.renderContext, this.buildChild);

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
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }
}
