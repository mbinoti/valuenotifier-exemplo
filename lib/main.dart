import 'package:demo4/common/theme.dart';
import 'package:demo4/screens/login.dart';
import 'package:demo4/screens/cart.dart';
import 'package:demo4/screens/catalog_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Simple App ValueListanableBuilder';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const MyLogin(),
        '/catalog': (context) => MyCatalog(),
        '/cart': (context) => const MyCart(),
      },
    );
  }
}
