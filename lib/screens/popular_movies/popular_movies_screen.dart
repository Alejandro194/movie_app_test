import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:movie_app_test/screens/movie_details/movie_details_screen.dart';

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
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: sectionHeading()),
            SizedBox(
              height: getPercentageOfScreenHeigth(90),
              child: Padding(
                  padding: const EdgeInsets.all(8.0), child: gridViewMovies(2)),
            )
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
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
          const Text(
            "CinemaSerch",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget sectionHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Most popular movies",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextButton(
            onPressed: () {
              Get.defaultDialog(
                  title: "Filter List",
                  content: Column(
                    children: [
                      TextFormField(
                        cursorColor: Colors.black,
                      )
                    ],
                  ));
            },
            child: const Icon(
              Icons.filter_alt_sharp,
              color: Colors.black,
            ))
      ],
    );
  }

  Widget gridViewMovies(int crossAxisCount) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, childAspectRatio: 1.0),
        itemBuilder: (context, index) {
          return movieStack(index);
        });
  }

  Widget movieStack(int index) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const MovieDetailsScreen());
      },
      child: Stack(
        children: [
          movieCard(index),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: moviePopularityRankingIndex(index),
          )
        ],
      ),
    );
  }

  Widget moviePopularityRankingIndex(int index) {
    return Container(
      width: getPercentageOfScreenHeigth(3),
      height: getPercentageOfScreenHeigth(3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: Colors.amber),
      child: Center(
          child: Text(
        (index + 1).toString(),
        style: const TextStyle(fontSize: 12),
      )),
    );
  }

  Widget movieCard(int index) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            movieImageRenderer(index),
            movieCardTitleRow(index),
            // Column(
            //   children: [
            //     TextButton(onPressed: () {}, child: Text("View details")),
            //   ],
            // )
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
              fit: BoxFit.scaleDown,
            ),
          ),
        )
      ],
    );
  }

  Widget movieCardTitleRow(int index) {
    return Row(
      children: const [
        Flexible(
          child: Text(
            "De Piraten van Hiernaast II: De Ninja's van de Overkant",
            overflow: TextOverflow.fade,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 12),
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
