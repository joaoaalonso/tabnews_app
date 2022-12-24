import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tabnews_app/extensions/dark_mode.dart';
import 'package:tabnews_app/favorites/favorites_view.dart';
import 'package:tabnews_app/home/home_view.dart';
import 'package:tabnews_app/profile_menu/profile_menu_view.dart';
import 'package:tabnews_app/search/search_view.dart';
import 'package:tabnews_app/shared/utils/orientation.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tab News',
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.white12,
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(27, 29, 33, 1),
        dividerColor: Colors.white24,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.grey.shade700,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(27, 29, 33, 1),
          selectedItemColor: Colors.white,
          unselectedItemColor: Color.fromRGBO(117, 119, 121, 1),
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          elevation: 0.0,
          color: Color.fromRGBO(63, 63, 63, 1),
          shape: Border(
            bottom: BorderSide(
              color: Colors.white30,
              width: 0.5,
            ),
          ),
        ),
      ),
      theme: ThemeData(
        primaryColor: Colors.black,
        colorScheme: const ColorScheme.light(
          primary: Colors.white,
          secondary: Color.fromRGBO(36, 41, 47, 1),
        ),
        scaffoldBackgroundColor: Colors.white,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.grey.shade300,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Color.fromRGBO(134, 134, 134, 1),
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0.0,
          color: Color.fromRGBO(248, 248, 250, 1),
          shape: Border(
            bottom: BorderSide(
              color: Colors.black45,
              width: 0.5,
            ),
          ),
        ),
      ),
      home: const AppScreen(title: 'Tab News'),
    );
  }
}

class TabItem {
  String title;
  IconData icon;
  Widget widget;
  ScrollController? scrollController;

  TabItem({
    required this.title,
    required this.icon,
    required this.widget,
    this.scrollController,
  });
}

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    OrientationHelper.lockOrientation();
  }

  void onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    } else {
      final scrollController = tabItems[_currentIndex].scrollController;
      if (scrollController != null) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      }
    }
  }

  final List<ScrollController> scrollControllers = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
  ];

  late final List<TabItem> tabItems = [
    TabItem(
      title: 'Início',
      icon: Icons.home,
      scrollController: scrollControllers[0],
      widget: const HomeView(),
    ),
    TabItem(
      title: 'Favoritos',
      icon: Icons.favorite,
      scrollController: scrollControllers[1],
      widget: FavoritesView(
        scrollController: scrollControllers[1],
      ),
    ),
    TabItem(
      title: 'Buscar',
      icon: Icons.search,
      scrollController: scrollControllers[2],
      widget: SearchView(
        scrollController: scrollControllers[2],
      ),
    ),
    TabItem(
      title: 'Perfil',
      icon: Icons.person,
      widget: const ProfileMenuView(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: const Color.fromRGBO(0, 0, 0, 0.6),
              width: context.isDarkMode ? 0.5 : 0.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onItemTapped,
          items: tabItems
              .map(
                (item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.title,
                ),
              )
              .toList(),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: tabItems.map((item) => item.widget).toList(),
      ),
    );
  }
}
