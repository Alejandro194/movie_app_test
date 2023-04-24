import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class PopularMoviesScreen extends StatefulWidget {
  const PopularMoviesScreen({super.key});

  @override
  State<PopularMoviesScreen> createState() => _PopularMoviesScreenState();
}

class _PopularMoviesScreenState extends State<PopularMoviesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: getPercentageOfScreenHeigth(90),
              child: Padding(
                  padding: const EdgeInsets.all(8.0), child: gridViewMovies(1)),
            )
          ],
        ),
      ),
    );
  }

  AppBar appBar(){
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(
                "assets/images/moviePlaceholderImage2.jpg",
                fit: BoxFit.fill,
              ),
            ),
            Text(
              "CinemaSerch",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      );
  }

  Widget gridViewMovies(int crossAxisCount) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, childAspectRatio: 1.05),
        itemBuilder: (context, index) {
          return movieStack(index);
        });
  }

  Widget movieStack(int index) {
    return Stack(
      children: [
        movieCard(index),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: moviePopularityRankingIndex(index),
        )
      ],
    );
  }

  Widget moviePopularityRankingIndex(int index) {
    return Container(
      width: getPercentageOfScreenHeigth(10),
      height: getPercentageOfScreenHeigth(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: Colors.amber),
      child: Center(
          child: Text(
        (index + 1).toString(),
        style: TextStyle(fontSize: 40),
      )),
    );
  }

  Widget movieCard(int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                movieImageRenderer(index),
                movieCardTitleRow(index),
              ],
            ),
            Column(
              children: [
                TextButton(onPressed: () {}, child: Text("View details")),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget movieImageRenderer(int index) {
    return Row(
      children: [
        Flexible(
          child: SizedBox(
            child: Image.asset(
              "assets/images/moviePlaceholderImage.jpg",
              fit: BoxFit.fill,
            ),
          ),
        )
      ],
    );
  }

  Widget movieCardTitleRow(int index) {
    return Row(
      children: [
        Flexible(
          child: Text(
            "De Piraten van Hiernaast II: De Ninja's van de Overkant",
            overflow: TextOverflow.fade,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  double getScreenHeight() {
    return Get.mediaQuery.size.height;
  }

  double getScreenWidth() {
    return Get.mediaQuery.size.width;
  }

  double getPercentageOfScreenHeigth(double percentage) {
    return (getScreenHeight() * percentage) / 100;
  }

  double getPercentageOfScreenWidth(double percentage) {
    return (getScreenWidth() * percentage) / 100;
  }
}
