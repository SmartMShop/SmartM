import 'dart:io';
import 'package:ar_smart_wear/Screens/TryOutfitsScreen.dart';
import 'package:ar_smart_wear/Widgets/CustButton.dart';
import 'package:ar_smart_wear/Widgets/ReportWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:height_slider/height_slider.dart';
import 'package:weight_slider/weight_slider.dart';

class BodyMeasurements extends StatefulWidget {
  static const id = "Body Measurements";
  final File image;
  final double distBet2Shoulders;
  final double distBetLeftHipAndShoulder;
  final double distBetRightHipAndShoulder;
  final double distanceBetTwoHips;
  final double boundingBoxInPixels;
  final double rightShoulderXco;
  final double rightShoulderYco;
  final double topPositionedShirt;
  final double distanceBetHipsAndAnkle;
  final double distanceBetFootAndAnkle;
  final bool man;

  const BodyMeasurements({
    this.image,
    this.distBet2Shoulders,
    this.distBetLeftHipAndShoulder,
    this.distBetRightHipAndShoulder,
    this.boundingBoxInPixels,
    this.rightShoulderXco,
    this.rightShoulderYco,
    this.topPositionedShirt,
    this.distanceBetTwoHips,
    this.distanceBetHipsAndAnkle,
    this.distanceBetFootAndAnkle,
    this.man,
  });
  @override
  _BodyMeasurementsState createState() => _BodyMeasurementsState(
      image: image,
      boundingBoxInPixels: boundingBoxInPixels,
      distBet2Shoulders: distBet2Shoulders,
      distBetLeftHipAndShoulder: distBetLeftHipAndShoulder,
      distBetRightHipAndShoulder: distBetRightHipAndShoulder,
      rightShoulderXco: rightShoulderXco,
      rightShoulderYco: rightShoulderYco,
      topPositionedShirt: topPositionedShirt,
      distanceBetTwoHips: distanceBetTwoHips,
      distanceBetHipsAndAnkle: distanceBetHipsAndAnkle,
      distanceBetFootAndAnkle: distanceBetFootAndAnkle,
      man: man);
}

class _BodyMeasurementsState extends State<BodyMeasurements> {
  _BodyMeasurementsState(
      {this.distanceBetHipsAndAnkle,
      this.distanceBetTwoHips,
      this.topPositionedShirt,
      this.rightShoulderXco,
      this.rightShoulderYco,
      this.boundingBoxInPixels,
      this.distBet2Shoulders,
      this.distBetLeftHipAndShoulder,
      this.distBetRightHipAndShoulder,
      this.image,
      this.distanceBetFootAndAnkle,
      this.man});

  final File image;
  final double distBet2Shoulders;
  final double distBetLeftHipAndShoulder;
  final double distBetRightHipAndShoulder;
  final double boundingBoxInPixels;
  final double rightShoulderXco;
  final double rightShoulderYco;
  final double topPositionedShirt;
  final double distanceBetTwoHips;
  final double distanceBetHipsAndAnkle;
  final double distanceBetFootAndAnkle;
  final bool man;

  //
  int height = 170;
  double waist = 0;
  double chest = 0;
  double shoulder = 0;
  int weight = 60;
  bool gotHeight = false;
  //

  double convertPixelsToCM(var cm1, double pixel_1, double pixel_2) {
    double cm2 = 0;
    cm2 = (pixel_2 * cm1) / pixel_1;
    return cm2.ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Size Report",
          style: GoogleFonts.gloriaHallelujah(fontSize: screenSize.width / 12),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/Images/background.jpeg"),
              fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: !gotHeight
              ? Center(
                  child: Stack(
                    children: [
                      HeightSlider(
                        sliderCircleColor: Colors.purple,
                        primaryColor: Colors.white,
                        numberLineColor: Colors.white,
                        height: height,
                        onChange: (val) {
                          setState(() {
                            height = val;
                          });
                        },
                        unit: 'cm', // optional
                        maxHeight: 210,
                        currentHeightTextColor: Colors.white,
                      ),
                      Positioned(
                        top: screenSize.height / 5,
                        left: screenSize.width / 4,
                        child: Container(
                          width: screenSize.width / 2,
                          height: screenSize.height / 15,
                          child: WeightSlider(
                            weight: weight,
                            minWeight: 40,
                            maxWeight: 130,
                            onChange: (val) =>
                                setState(() => this.weight = val),
                            unit: 'kg', // optional
                          ),
                        ),
                      ),
                      Positioned(
                          left: screenSize.width / 12,
                          top: screenSize.height / 15,
                          child: CustButton(
                            onTap: () {
                              setState(() {
                                chest = convertPixelsToCM(height,
                                    boundingBoxInPixels, distBet2Shoulders);
                                waist = convertPixelsToCM(height,
                                    boundingBoxInPixels, distanceBetTwoHips);
                                gotHeight = true;
                              });
                            },
                            borderColor: Colors.purple,
                            fillColor: Colors.purple,
                            screenSize: screenSize,
                            text: "Next",
                            fontSize: screenSize.width / 14,
                            textColor: Colors.white,
                            heightDiv: screenSize.height / 60,
                            widthDiv: screenSize.width / 120,
                          )),
                    ],
                  ),
                )
              : Container(
                  height: screenSize.height,
                  width: screenSize.width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenSize.height / 25,
                      ),
                      ReportWidget(
                        screenSize: screenSize,
                        height: height,
                        waist: waist,
                        chest: chest,
                        image: image,
                        weight: weight,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustButton(
                            screenSize: screenSize,
                            onTap: () {
                              setState(() {
                                gotHeight = false;
                              });
                            },
                            text: "Remeasure",
                            textColor: Colors.white,
                            borderColor: Colors.purple,
                            fillColor: Colors.purple,
                            heightDiv: screenSize.height / 70,
                            widthDiv: screenSize.width / 140,
                            fontSize: screenSize.width / 18,
                          ),
                          SizedBox(
                            width: screenSize.width / 30,
                          ),
                          CustButton(
                            screenSize: screenSize,
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TryOutfits(
                                              image: image,
                                              distBet2Shoulders:
                                                  distBet2Shoulders,
                                              distBetHipsAndShoulders:
                                                  distBetRightHipAndShoulder >
                                                          distBetLeftHipAndShoulder
                                                      ? distBetRightHipAndShoulder
                                                      : distBetLeftHipAndShoulder,
                                              rightShoulderXco:
                                                  rightShoulderXco,
                                              rightShoulderYco:
                                                  rightShoulderYco,
                                              boundingBoxInPixels:
                                                  boundingBoxInPixels,
                                              topPositionedShirt:
                                                  topPositionedShirt,
                                              distanceBetHipsAndAnkle:
                                                  distanceBetHipsAndAnkle,
                                              distanceBetTwoHips:
                                                  distanceBetTwoHips,
                                              distanceBetFootAndAnkle:
                                                  distanceBetFootAndAnkle,
                                              man: man,
                                            )));
                              });
                            },
                            text: "Try Outfits",
                            textColor: Colors.white,
                            borderColor: Colors.purple,
                            fillColor: Colors.purple,
                            heightDiv: screenSize.height / 70,
                            widthDiv: screenSize.width / 140,
                            fontSize: screenSize.width / 18,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
