import 'package:flutter/material.dart';
import 'package:formvalidation/src/blocs/provider.dart';
import 'package:formvalidation/src/pages/home_page.dart';
import 'package:formvalidation/src/pages/login_page.dart';
import 'package:formvalidation/src/pages/product_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color.fromRGBO(100, 42, 63, 1.0),
          accentColor: Color.fromRGBO(158, 60, 96, 1.0),
          buttonColor: Color.fromRGBO(100, 42, 63, 1.0),
          textTheme: TextTheme(
            button: TextStyle(color: Colors.white)
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Color.fromRGBO(158, 60, 96, 1.0),
          buttonColor: Color.fromRGBO(100, 42, 63, 1.0),
        ),
        themeMode: ThemeMode.dark,
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'home': (BuildContext context) => HomePage(),
          'product': (BuildContext context) => ProductPage()
        }
      ),
    );
  }
}