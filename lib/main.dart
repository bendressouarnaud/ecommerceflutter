import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/io_client.dart';

import 'newpage.dart';



Future<SecurityContext> get globalContext async {
  final sslCert = await rootBundle.load('assets/ankkappcom.pem');
  SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
  securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
  return securityContext;
}

Future<http.Client> getSSLPinningClient() async {
  HttpClient client = HttpClient(context: await globalContext);
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => false;
  IOClient ioClient = IOClient(client);
  return ioClient;
}

//void main() {
Future main() async {
  await dotenv.load(fileName: "variable.env");
  //
  //WidgetsFlutterBinding.ensureInitialized();

  final client = await getSSLPinningClient();

  runApp( MyApp.setClient(client));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  MyApp.setClient(this.client);
  late http.Client client;

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
      home: NewsPage(client: client),

    );
  }
}