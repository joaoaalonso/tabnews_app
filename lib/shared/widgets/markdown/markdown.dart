import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:markdown_widget/config/highlight_themes.dart' as theme;
import 'package:tabnews_app/extensions/dark_mode.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tabnews_app/shared/utils/open_link.dart';
import 'package:tabnews_app/shared/widgets/image_viewer.dart';
import 'package:tabnews_app/shared/widgets/markdown/img_render.dart';

import 'h2_render.dart';

class Markdown extends StatelessWidget {
  final String body;

  const Markdown({
    super.key,
    required this.body,
  });

  final useHtml = true;

  @override
  Widget build(BuildContext context) {
    if (useHtml) {
      return _HtmlRender(body: body);
    } else {
      return _MarkdownRender(body: body);
    }
  }
}

class _HtmlRender extends StatelessWidget {
  final String body;

  const _HtmlRender({required this.body});

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
      },
      customRenders: {
        tagMatcher('img'): CustomRender.widget(
          widget: (renderContext, buildChild) =>
              ImgRender(renderContext, buildChild),
        ),
        tagMatcher('h2'): CustomRender.widget(
          widget: (renderContext, buildChild) =>
              H2Render(renderContext, buildChild),
        ),
      },
    );
  }
}

class _MarkdownRender extends StatelessWidget {
  final String body;

  const _MarkdownRender({required this.body});

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
