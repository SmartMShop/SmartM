import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustButton extends StatelessWidget {
  const CustButton({
    Key key,
    @required this.screenSize,
    this.text,
    this.onTap,
    this.heightDiv = 8,
    this.widthDiv = 1.5,
    this.fillColor = Colors.transparent,
    this.textColor = Colors.white,
    this.fontSize = 30,
    this.borderColor = Colors.white,
  }) : super(key: key);

  final Size screenSize;
  final String text;
  final Function onTap;
  final double fontSize;
  final double heightDiv;
  final double widthDiv;
  final Color fillColor;
  final Color textColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: screenSize.height / heightDiv,
          width: screenSize.width / widthDiv,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: borderColor,
              width: 7,
            ),
          ),
          child: Center(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.gloriaHallelujah(
                fontSize: fontSize,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
