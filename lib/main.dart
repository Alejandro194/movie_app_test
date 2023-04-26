import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app_test/controllers/error_controller.dart';
import 'package:movie_app_test/controllers/movie_controller.dart';
import 'package:movie_app_test/screens/movie_details/movie_details_screen.dart';
import 'package:movie_app_test/screens/popular_movies/popular_movies_screen.dart';
import 'package:movie_app_test/screens/user_settings/user_settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(MovieController());
    Get.put(ErrorController());
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        canvasColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: const PopularMoviesScreen(),
    );
  }
}
