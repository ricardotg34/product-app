import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:formvalidation/src/blocs/provider.dart';
import 'package:formvalidation/src/pages/home_page.dart';
import 'package:formvalidation/src/pages/login_page.dart';
import 'package:formvalidation/src/pages/product_page.dart';
import 'package:formvalidation/src/pages/register_page.dart';
import 'package:formvalidation/src/utils/user_preferences.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final prefs = new UserPreferences();
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color.fromRGBO(100, 42, 63, 1.0),
          accentColor: Color.fromRGBO(158, 60, 96, 1.0),
          buttonColor: Color.fromRGBO(100, 42, 63, 1.0),
          toggleableActiveColor: Color.fromRGBO(158, 60, 96, 1.0),
          textTheme: TextTheme(
            button: TextStyle(color: Colors.white)
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Color.fromRGBO(158, 60, 96, 1.0),
          buttonColor: Color.fromRGBO(100, 42, 63, 1.0),
          toggleableActiveColor: Color.fromRGBO(158, 60, 96, 1.0),
        ),
        themeMode: ThemeMode.dark,
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'register': (BuildContext context) => RegisterPage(),
          'home': (BuildContext context) => HomePage(),
          'product': (BuildContext context) => ProductPage()
        }
      ),
    );
  }
}