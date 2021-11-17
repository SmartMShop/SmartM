import 'dart:io';

import 'package:ar_smart_wear/Widgets/NumBelowText.dart';
import 'package:flutter/material.dart';

class ReportWidget extends StatelessWidget {
  const ReportWidget({
    Key key,
    @required this.screenSize,
    @required this.height,
    @required this.waist,
    @required this.chest,
    @required this.image,
    this.weight,
  });

  final Size screenSize;
  final int height;
  final double waist;
  final double chest;
  final File image;
  final int weight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenSize.height / 1.6,
      width: screenSize.width / 1.05,
      child: Row(
        children: [
          SizedBox(
            width: screenSize.width / 20,
          ),
          Column(
            children: [
              NumBelowText(
                screenSize: screenSize,
                height: height.toDouble(),
                text: "Height",
              ),
              NumBelowText(
                screenSize: screenSize,
                height: weight.toDouble(),
                text: "Weight",
              ),
              NumBelowText(
                screenSize: screenSize,
                height: waist,
                text: "Waist",
              ),
              NumBelowText(
                screenSize: screenSize,
                height: chest,
                text: "chest",
              ),
            ],
          ),
          SizedBox(
            width: screenSize.width / 20,
          ),
          Container(
            height: screenSize.height / 2.2,
            width: screenSize.width / 72,
            color: Colors.blue,
          ),
          SizedBox(
            width: screenSize.width / 30,
          ),
          Container(
            height: screenSize.height / 1.8,
            width: screenSize.width / 2.3,
            child: Image.file(image),
          ),
        ],
      ),
    );
  }
}
