import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviewBox extends StatelessWidget {
  const PreviewBox({
    @required this.screenSize,
    @required this.imagePath,
  });

  final Size screenSize;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenSize.height / 5,
      width: screenSize.width / 3.5,
      child: Image.asset(
        imagePath,
      ),
      decoration: BoxDecoration(
          border:
              Border.all(color: Colors.purple, width: screenSize.width / 70)),
    );
  }
}
