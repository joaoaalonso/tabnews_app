import 'package:flutter/material.dart';
import 'package:tabnews_app/shared/widgets/default_app_bar.dart';

class ProfileMenuView extends StatelessWidget {
  const ProfileMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: DefaultAppBar(title: 'Perfil'),
      body: Center(
        child: Text('Em breve :)'),
      ),
    );
  }
}
