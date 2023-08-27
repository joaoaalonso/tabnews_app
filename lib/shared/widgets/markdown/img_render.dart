import 'package:flutter/material.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:tabnews_app/shared/widgets/image_viewer.dart';

class ImgRender extends StatelessWidget {
  final RenderContext renderContext;
  final List<InlineSpan> Function() buildChild;

  const ImgRender(this.renderContext, this.buildChild, {super.key});

  @override
  Widget build(BuildContext context) {
    final url = renderContext.tree.attributes['src'];
    return url != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImageViewer(uri: Uri.parse(url)),
          )
        : const SizedBox();
  }
}
