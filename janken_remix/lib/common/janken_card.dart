import 'package:flutter/material.dart';

class JankenCard extends StatelessWidget {
  JankenCard({this.image, @required this.onTap});

  final String image;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            image,
            width: 120,
            height: 120,
          ),
        ),
      ),
    );
  }
}
