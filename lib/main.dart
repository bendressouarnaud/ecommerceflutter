import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'newpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // https://medium.flutterdevs.com/explore-shimmer-animation-effect-in-flutter-7b0e46a9c722
  // https://www.digitalocean.com/community/tutorials/flutter-flutter-http
  // https://docs.flutter.dev/cookbook/networking/send-data

  //https://developer.school/tutorials/how-to-use-environment-variables-with-flutter-dotenv

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    //
    //WidgetsFlutterBinding.ensureInitialized();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NewsPage(),

    );
  }
}