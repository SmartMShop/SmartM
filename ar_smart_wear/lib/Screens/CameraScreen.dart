import 'dart:io';
import 'dart:math';

import 'package:ar_smart_wear/Screens/BodyMeasurementsScreen.dart';
import 'package:ar_smart_wear/Widgets/CustButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";

class CameraScreen extends StatefulWidget {
  static const id = 'CameraScreen';
  final bool man;

  const CameraScreen({this.man});
  @override
  _CameraScreenState createState() => _CameraScreenState(man: man);
}

class _CameraScreenState extends State<CameraScreen> {
  final bool man;

  String _model = ssd;
  File _image;

  double _imageWidth;
  double _imageHeight;
  bool _busy = false;

  List _recognitions;

  PoseLandmark shirtRightShoulderCoordinates;
  PoseLandmark shirtLeftShoulderCoordinates;
  PoseLandmark leftHipCoordinate;
  PoseLandmark rightHipCoordinate;
  double distanceBetween2ShouldersInPixels = 0;
  double distanceBetLeftHipAndShoulderInPixels = 0;
  double distanceBetRightHipAndShoulderInPixels = 0;
  double distanceBetTwoHipsInPixels = 0;
  double distanceBetHipsAndAnkle = 0;
  double distanceBetFootAndAnkle = 0;
  double boundingBoxHeightInPixels = 0;
  double boundingBoxWidthInPixels = 0;

  double factorX;
  double factorY;

  double leftPositionedShirt;
  double topPositionedShirt;

  _CameraScreenState({this.man});

  @override
  void initState() {
    super.initState();
    _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }

  loadModel() async {
    Tflite.close();
    try {
      String res;
      if (_model == yolo) {
        res = await Tflite.loadModel(
          model: "assets/tflite/yolov2_tiny.tflite",
          labels: "assets/tflite/yolov2_tiny.txt",
        );
      } else {
        res = await Tflite.loadModel(
          model: "assets/tflite/ssd_mobilenet.tflite",
          labels: "assets/tflite/ssd_mobilenet.txt",
        );
      }
      print(res);
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  selectFromImagePicker(bool camera) async {
    var image;
    if (!camera) {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    } else {
      image = await ImagePicker().pickImage(source: ImageSource.camera);
    }
    if (image == null) return;
    setState(() {
      _busy = true;
    });
    predictImage(File(image.path));
    detectPose(File(image.path));
  }

  predictImage(File image) async {
    if (image == null) return;

    if (_model == yolo) {
      await yolov2Tiny(image);
    } else {
      await ssdMobileNet(image);
    }

    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _imageWidth = info.image.width.toDouble();
            _imageHeight = info.image.height.toDouble();
          });
        })));

    setState(() {
      _image = image;
      _busy = false;
    });
  }

  yolov2Tiny(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path,
        model: "YOLO",
        threshold: 0.3,
        imageMean: 0.0,
        imageStd: 255.0,
        numResultsPerClass: 1);

    setState(() {
      _recognitions = recognitions;
    });
  }

  ssdMobileNet(File image) async {
    var recognitions = new List<dynamic>.from(await Tflite.detectObjectOnImage(
        path: image.path, numResultsPerClass: 1));
    var temp = new List<dynamic>.from(recognitions);

    dynamic recObject;
    for (recObject in recognitions) {
      if (recObject["detectedClass"] != "person") {
        // to only Detect Persons
        temp.removeAt(temp.indexOf(recObject));
      }
    }
    setState(() {
      _recognitions = temp;
    });
  }

  detectPose(File image) async {
    final inputImage = InputImage.fromFile(image);
    final poseDetector = GoogleMlKit.vision.poseDetector();
    final List<Pose> poses = await poseDetector.processImage(inputImage);

    PoseLandmark leftKnee;
    PoseLandmark rightKnee;
    PoseLandmark leftFoot;
    PoseLandmark rightFoot;
    PoseLandmark leftAnkle;
    for (Pose pose in poses) {
      // to access specific landmarks
      //getting both shoulders coordinates so we can adjust the shirt relatively with 2D position
      shirtLeftShoulderCoordinates =
          pose.landmarks[PoseLandmarkType.leftShoulder];
      shirtRightShoulderCoordinates =
          pose.landmarks[PoseLandmarkType.rightShoulder];
      leftHipCoordinate = pose.landmarks[PoseLandmarkType.leftHip];
      rightHipCoordinate = pose.landmarks[PoseLandmarkType.rightHip];
      leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
      rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
      leftFoot = pose.landmarks[PoseLandmarkType.leftFootIndex];
      rightFoot = pose.landmarks[PoseLandmarkType.rightFootIndex];
      leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
    }
    print("RightHIP ${rightHipCoordinate.x}   ${rightHipCoordinate.y}");
    print("LeftHIP ${leftHipCoordinate.x}   ${leftHipCoordinate.y}");
    //
    //getting distance between the 2 shoulders points using their coordinates and distance bet 2 points law
    //d=√((x2-x1)²+(y2-y1)²)
    //considering the left shoulder to be x2 as on the coordinate it's further on the x-axis
    //we will use the reference of the whole body height given in CMs to convert any pixels length to CMs
    //
    distanceBetween2ShouldersInPixels = distanceBet2Points(
        shirtRightShoulderCoordinates.x,
        shirtLeftShoulderCoordinates.x,
        shirtRightShoulderCoordinates.y,
        shirtLeftShoulderCoordinates.y);

    print("DIS $distanceBetween2ShouldersInPixels");

    //getting the distance between the start of the hip and the shoulder to determine the height of the container that
    //will contain the shirt
    distanceBetLeftHipAndShoulderInPixels = distanceBet2Points(
        leftHipCoordinate.x,
        shirtLeftShoulderCoordinates.x,
        leftHipCoordinate.y,
        shirtLeftShoulderCoordinates.y);

    //
    //we get both distances so we can assign our container height to fit the bigger distance
    //
    distanceBetRightHipAndShoulderInPixels = distanceBet2Points(
        rightHipCoordinate.x,
        shirtRightShoulderCoordinates.x,
        rightHipCoordinate.y,
        shirtRightShoulderCoordinates.y);

    //
    //getting distance between 2 hips so we can assign it to pants width
    //
    // distanceBetTwoHipsInPixels = distanceBet2Points(leftHipCoordinate.x,
    //     rightHipCoordinate.x, leftHipCoordinate.y, rightHipCoordinate.y);
    distanceBetTwoHipsInPixels =
        distanceBet2Points(leftKnee.x, rightKnee.x, leftKnee.y, rightKnee.y);

    //
    distanceBetHipsAndAnkle = distanceBet2Points(
        leftHipCoordinate.x, leftAnkle.x, leftHipCoordinate.y, leftAnkle.y);
    //
    distanceBetFootAndAnkle =
        distanceBet2Points(leftFoot.x, leftAnkle.x, leftFoot.y, leftAnkle.y);

    print(distanceBet2Points(leftFoot.x, rightFoot.x, leftFoot.y, rightFoot.y));
    print("DIST FOOT ANKLE $distanceBetTwoHipsInPixels");
  }

  double distanceBet2Points(double x1, double x2, double y1, double y2) {
    double distance = sqrt(pow((x2 - x1), 2) + pow((y2 - y1), 2));
    return distance;
  }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageWidth == null || _imageHeight == null) return [];

    factorX = screen.width;
    factorY = _imageHeight / _imageWidth * screen.width;

    Color red = Colors.red;

    return _recognitions.map((re) {
      setState(() {
        boundingBoxHeightInPixels = re["rect"]["h"] * factorY;
        boundingBoxWidthInPixels = re["rect"]["w"] * factorX;
        leftPositionedShirt = re["rect"]["x"] * factorX;
        topPositionedShirt = re["rect"]["y"] * factorY;
      });
      print("BoundingBoxWIDTH $boundingBoxWidthInPixels");
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: red,
            width: 3,
          )),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = red,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> stackChildren = [];

    stackChildren.add(Positioned(
      top: 0.0,
      left: 0.0,
      width: size.width,
      child: _image == null
          ? Container(
              height: size.height / 1.5,
              width: size.width,
              child: Center(
                child: Text(
                  "No Image was \nSelected",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.gloriaHallelujah(
                      fontSize: size.width / 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            )
          : Image.file(_image),
    ));

    stackChildren.addAll(renderBoxes(size));

    if (_busy) {
      stackChildren.add(Center(
        child: CircularProgressIndicator(),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Pick an Image",
          style: GoogleFonts.gloriaHallelujah(fontSize: size.width / 12),
        ),
        backgroundColor: Colors.purple,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustButton(
              screenSize: size,
              onTap: () {
                if (_image == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.blue,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    content: Text(
                      "Please Upload an Image First",
                      style: GoogleFonts.gloriaHallelujah(),
                    ),
                  ));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BodyMeasurements(
                                image: _image,
                                distBet2Shoulders: boundingBoxWidthInPixels,
                                distBetLeftHipAndShoulder:
                                    distanceBetLeftHipAndShoulderInPixels,
                                distBetRightHipAndShoulder:
                                    distanceBetRightHipAndShoulderInPixels,
                                boundingBoxInPixels: boundingBoxHeightInPixels,
                                rightShoulderXco: leftPositionedShirt,
                                rightShoulderYco:
                                    shirtRightShoulderCoordinates.y,
                                topPositionedShirt: topPositionedShirt,
                                distanceBetTwoHips: distanceBetTwoHipsInPixels,
                                distanceBetHipsAndAnkle:
                                    distanceBetHipsAndAnkle,
                                distanceBetFootAndAnkle:
                                    distanceBetFootAndAnkle,
                                man: man,
                              )));
                }
              },
              text: "Next",
              fontSize: size.width / 13,
              heightDiv: size.height / 70,
              widthDiv: size.width / 80,
              borderColor: Colors.purple,
              fillColor: Colors.purple,
              textColor: Colors.white,
            ),
            SizedBox(
              width: size.width / 20,
            ),
            FloatingActionButton(
              child: Icon(Icons.camera),
              backgroundColor: Colors.purple,
              onPressed: () {
                selectFromImagePicker(true);
              },
              heroTag: "btn2",
            ),
            SizedBox(
              width: size.width / 25,
            ),
            FloatingActionButton(
              backgroundColor: Colors.purple,
              heroTag: "btn1",
              child: Icon(Icons.image),
              tooltip: "Pick Image from gallery",
              onPressed: () {
                selectFromImagePicker(false);
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/Images/background.jpeg"),
              fit: BoxFit.cover),
        ),
        child: Stack(
          children: stackChildren,
        ),
      ),
    );
  }
}
