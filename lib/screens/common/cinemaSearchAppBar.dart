import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CinemaSearchAppBar extends StatelessWidget with PreferredSizeWidget {
  const CinemaSearchAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
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
}