import 'package:flutter/material.dart';
import 'package:food_recipe_app/favoritePage.dart';
import 'package:food_recipe_app/homeScreen.dart';
import 'package:food_recipe_app/sqflite/sql.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Sql.instance.open();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0; // Move _selectedIndex here

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(),
      Favorite(),
      HomeScreen(),
      HomeScreen(),
      HomeScreen(),// Corrected to 'FavoritePage'
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              label: '',
            ),


          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFF02967B),
          unselectedItemColor: Colors.black,
          iconSize: 30,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          elevation: 10,
        ),
        body: pages[_selectedIndex],
      ),
    );
  }
}
