
import 'dart:async';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision_example/views/result_page.dart';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../detector_painters.dart';


class ResultPage extends StatefulWidget {



  final String imgpath;

  const ResultPage({
    Key key,
    @required this.imgpath,

  }) : super(key: key);

  @override
  _ResultPageState createState() => new _ResultPageState();

}
class _ResultPageState extends State<ResultPage> {

  File _imageFile;
  Size _imageSize;
  dynamic _scanResults;
  Detector _currentDetector = Detector.label;
  final ImageLabeler _imageLabeler = FirebaseVision.instance.imageLabeler();
  String footprint = "Loading";
  String name = "Loading";
  String description = "Loading";

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _getAndScanImagestart();
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  Future<void> _getAndScanImagestart() async {
    setState(() {
      _imageFile = null;
      _imageSize = null;
    });

    final File imageFile = File(widget.imgpath);

    if (imageFile != null) {
      _getImageSize(imageFile);
      _scanImage(imageFile);
    }

    setState(() {
      _imageFile = imageFile;
    });
  }

  Future<void> _getAndScanImage() async {
    setState(() {
      _imageFile = null;
      _imageSize = null;
    });

    final File imageFile =
    await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      _getImageSize(imageFile);
      _scanImage(imageFile);
    }

    setState(() {
      _imageFile = imageFile;
    });
  }

  Future<void> _scanImage(File imageFile) async {
    setState(() {
      _scanResults = null;
    });

    final FirebaseVisionImage visionImage =
    FirebaseVisionImage.fromFile(imageFile);

    dynamic results;
    switch (_currentDetector) {
      case Detector.label:
        results = await _imageLabeler.processImage(visionImage);
        break;
      default:
        return;
    }

    setState(() {
      _scanResults = results;
    });
  }

  CustomPaint _buildResults(Size imageSize, dynamic results) {
    CustomPainter painter;

    switch (_currentDetector) {
      case Detector.label:
        painter = LabelDetectorPainter(_imageSize, results);
        break;
      default:
        break;
    }

    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.file(_imageFile).image,
          fit: BoxFit.fill,
        ),
      ),
      child: _imageSize == null || _scanResults == null
          ? const Center(
        child: Text(
          'Scanning...',
          style: TextStyle(
            color: Colors.green,
            fontSize: 30.0,
          ),
        ),
      )
          : _buildResults(_imageSize, _scanResults),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Page'),
        backgroundColor: Colors.black87,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getAndScanImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
      body:
      Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black ,Colors.white
                  ]
              )
          ),
          child: ListView(
              padding: EdgeInsets.all(10),
              children: <Widget>[

                SizedBox(
                  height: 420,
                  width: 350,
                  child: Column(

                      children: <Widget>[
                        Container(
                          height: 420,
                          child: _buildImage(),
                        )
                      ]
                  ),
                ),
                Container(
                  height: 80,
                  width: 150,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple,  Colors.white,Colors.white,Colors.purple,],
                      ),borderRadius: BorderRadius.circular(66)
                  ),
                  child: Text(name,
                    style: TextStyle(
                        fontSize: 40.0
                    ),
                  ),
                  alignment: Alignment(0.0, 0.0),
                ),
                SizedBox(
                  height: 15,
                  width: 20,),
                Container(
                  height: 80,
                  width: 120,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.deepOrangeAccent],
                      ),borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text(footprint,
                    style: TextStyle(
                        fontSize: 29.0
                    ),
                  ),
                  alignment: Alignment(0.0, 0.0),
                ),
                SizedBox(
                  height: 15,
                  width: 20,),
                Container(
                  height: 80,
                  width: 120,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.deepOrangeAccent],
                      ),borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text(footprint,
                    style: TextStyle(
                        fontSize: 29.0
                    ),
                  ),
                  alignment: Alignment(0.0, 0.0),
                ),
                Text(description,
                  style: TextStyle(fontWeight: FontWeight.bold,height: 3, fontSize: 20),),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 200.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        width: 200.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: ExactAssetImage('assets/carbon1.jpg'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),

                      ),
                      SizedBox(
                        height: 20,
                        width: 20,),
                      Container(
                        width: 200.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: ExactAssetImage('assets/carbon2.jpg'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),

                      ),
                      SizedBox(
                        height: 20,
                        width: 20,),
                      Container(
                        width: 200.0,
                        decoration: BoxDecoration(
                          image:  DecorationImage(
                            image: ExactAssetImage('assets/carbon3.jpg'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),

                      ),
                      SizedBox(
                        height: 20,
                        width: 20,),
                      Container(
                        width: 200.0,
                        decoration:  BoxDecoration(
                          image:  DecorationImage(
                            image: ExactAssetImage('assets/carbon4.jpg'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),

                      ),
                      SizedBox(
                        height: 20,
                        width: 20,),
                    ],
                  ),
                )

              ]
          )
      ),


    );



  }

  @override
  void dispose() {
    _imageLabeler.close();
    super.dispose();
  }
}