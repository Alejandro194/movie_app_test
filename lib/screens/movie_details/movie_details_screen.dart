import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({super.key});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  List<String> movieInfo = [
    "En",
    "US",
    "1992",
    "130 min",
    "Horror, Science Fiction"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(children: [
            movieImageRenderer(),
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  movieTitleRow(),
                  movieInfoList(),
                  const SizedBox(
                    height: 12,
                  ),
                  movieOverviewRow(),
                  const SizedBox(
                    height: 12,
                  ),
                  ratingStars(7, 10),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
      title: SizedBox(
        width: 185,
        child: Row(
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
      ),
    );
  }

  Widget movieImageRenderer() {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: BoxDecoration(border: Border.all()),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                  height: getPercentageOfScreenHeigth(45),
                  child: Image.asset(
                    "assets/images/moviePlaceholderImage.jpg",
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget movieTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        Flexible(
          child: Text(
            "De Piraten van Hiernaast II: De Ninja's van de Overkant",
            overflow: TextOverflow.fade,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget movieInfoList() {
    return SizedBox(
      height: 30,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movieInfo.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
              child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 0.2)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(movieInfo[index], style: TextStyle(fontWeight: FontWeight.w300),),
                  )),
            );
          }),
    );
  }

  Widget movieOverviewRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        Flexible(
          child: Text(
            "While working underground to fix a water main, Brooklyn plumbers—and brothers—Mario and Luigi are transported down a mysterious pipe and wander into a magical new world. But when the brothers are separated, Mario embarks on an epic quest to find Luigi.",
            overflow: TextOverflow.fade,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget movieEconomicInfo() {
    return Column(
      children: [
        Row(
          children: [
            Text("Budget : "),
            Text("63000000 USD"),
          ],
        ),
        Row(
          children: [
            Text("Revenue : "),
            Text("100853753 USD"),
          ],
        )
      ],
    );
  }

  Widget ratingStars(double initialRating, int maxRating) {
    return Column(
      children: [
        RatingBar.builder(
          ignoreGestures: true,
          itemSize: 30,
          initialRating: initialRating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: maxRating,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        const SizedBox(
          height: 8,
        ),
        movieRatingRow(),
      ],
    );
  }

  Widget movieRatingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Flexible(
          child: Text(
            "Rating: ",
            overflow: TextOverflow.fade,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Flexible(
          child: Text(
            "7/10 ",
            overflow: TextOverflow.fade,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Flexible(
          child: Text(
            "(3408 votes)",
            overflow: TextOverflow.fade,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14),
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
