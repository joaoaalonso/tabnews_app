import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:tabnews_app/shared/utils/open_link.dart';
import 'package:tabnews_app/shared/widgets/markdown/code_render.dart';
import 'package:tabnews_app/shared/widgets/markdown/pre_render.dart';
import 'package:tabnews_app/shared/widgets/markdown/img_render.dart';

import 'h_render.dart';

class Markdown extends StatelessWidget {
  final String body;

  const Markdown({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final html = markdown.markdownToHtml(body);

    return Html(
      data: html,
      onLinkTap: (url, renderContext, attributes, element) {
        openUrl(context, url);
      },
      style: {
        'a': Style(
          textDecoration: TextDecoration.none,
        ),
        'body': Style(
          margin: Margins.zero,
        ),
        'hr': Style(
          margin: Margins.only(top: 12, bottom: 12),
        ),
      },
      customRenders: {
        tagMatcher('img'): CustomRender.widget(
          widget: (renderContext, buildChild) =>
              ImgRender(renderContext, buildChild),
        ),
        tagMatcher('h1'): CustomRender.widget(
          widget: (renderContext, buildChild) =>
              HRender(26.0, renderContext, buildChild),
        ),
        tagMatcher('h2'): CustomRender.widget(
          widget: (renderContext, buildChild) =>
              HRender(18.0, renderContext, buildChild),
        ),
        tagMatcher('code'): CustomRender.widget(
          widget: (renderContext, buildChild) =>
              CodeRender(renderContext, buildChild),
        ),
        tagMatcher('pre'): CustomRender.widget(
          widget: (renderContext, buildChild) =>
              PreRender(renderContext, buildChild),
        ),
      },
    );
  }
}
