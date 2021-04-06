import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weight/pages/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            appBarTheme: AppBarTheme(brightness: Brightness.dark),
            textTheme:
                GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme)),
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: SplashPage());
  }
}
