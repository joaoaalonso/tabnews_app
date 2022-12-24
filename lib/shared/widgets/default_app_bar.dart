import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tabnews_app/extensions/dark_mode.dart';

class DefaultAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool showLogo;
  final PreferredSizeWidget? bottom;

  const DefaultAppBar(
      {super.key, this.title = '', this.showLogo = true, this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          if (showLogo)
            SvgPicture.asset(
              context.isDarkMode
                  ? 'lib/assets/logo.svg'
                  : 'lib/assets/logo-dark.svg',
              semanticsLabel: 'TabNews logo',
            ),
          if (showLogo) const SizedBox(width: 10.0),
          Text(title),
        ],
      ),
      foregroundColor: context.isDarkMode ? Colors.white : Colors.black,
      centerTitle: false,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + (bottom != null ? kTextTabBarHeight - 28 : 0));
}
