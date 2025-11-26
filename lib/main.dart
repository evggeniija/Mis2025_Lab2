import 'package:flutter/material.dart';
import 'screens/categories_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TheMealDB Recipes',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const CategoriesScreen(),
    );
  }
}
