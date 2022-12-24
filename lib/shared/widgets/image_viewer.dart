import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:tabnews_app/shared/utils/orientation.dart';

class ImageViewer extends StatelessWidget {
  final Uri uri;

  const ImageViewer({super.key, required this.uri});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) =>
                _FullscreenImage(uri: uri),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      child: Hero(
        tag: "image-${uri.toString()}",
        child: Image.network(
          uri.toString(),
        ),
      ),
    );
  }
}

class _FullscreenImage extends StatefulWidget {
  final Uri uri;

  const _FullscreenImage({required this.uri});

  @override
  State<_FullscreenImage> createState() => _FullscreenImageState();
}

class _FullscreenImageState extends State<_FullscreenImage>
    with SingleTickerProviderStateMixin {
  TapDownDetails? tapDownDetails;
  late TransformationController transformationController;

  Animation<Matrix4>? animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    OrientationHelper.unlockOrientation();

    transformationController = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        transformationController.value = animation!.value;
      });
  }

  @override
  void dispose() {
    transformationController.dispose();
    animationController.dispose();
    OrientationHelper.lockOrientation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () {
        Navigator.of(context).pop();
      },
      direction: DismissiblePageDismissDirection.down,
      isFullScreen: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: GestureDetector(
                  onDoubleTapDown: (details) => tapDownDetails = details,
                  onDoubleTap: () {
                    const scale = 3.0;

                    final position = tapDownDetails!.localPosition;
                    final x = -position.dx * (scale - 1);
                    final y = -position.dy * (scale - 1);
                    final zoomed = Matrix4.identity()
                      ..translate(x, y)
                      ..scale(scale);

                    final end = transformationController.value.isIdentity()
                        ? zoomed
                        : Matrix4.identity();

                    animation = Matrix4Tween(
                      begin: transformationController.value,
                      end: end,
                    ).animate(
                      CurveTween(curve: Curves.easeOut)
                          .animate(animationController),
                    );

                    animationController.forward(from: 0);
                  },
                  child: InteractiveViewer(
                    clipBehavior: Clip.none,
                    panEnabled: true,
                    scaleEnabled: true,
                    transformationController: transformationController,
                    child: Hero(
                      tag: "image-${widget.uri.toString()}",
                      child: Image.network(
                        widget.uri.toString(),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
