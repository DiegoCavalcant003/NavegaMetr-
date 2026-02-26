import 'package:flutter/material.dart';

import 'login_page.dart';
import 'home_page.dart';
import 'permission_page.dart';
import 'travel_page.dart';
import 'history_page.dart';
import 'cadastro_page.dart';

void main() {
  runApp(const NavegaMetroApp());
}

class NavegaMetroApp extends StatelessWidget {
  const NavegaMetroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NavegaMêtro',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginPage(),
        '/permission': (context) => const PermissionPage(),
        '/home': (context) => const HomePage(),
        '/history': (context) => const HistoryPage(),
        '/cadastro': (context) => const CadastroPage(),
      },
    );
  }
}