import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  File? _image;
  List? _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {
        // Model is loaded, but we wait for user to pick image
        isLoading = false; 
      });
    });
  }

  // 1. Detect Image Function
  detectImage(File image) async {
    // Set loading to true while detection happens (optional, for UI feedback)
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    print("Result is: $output");
    setState(() {
      _output = output;
      // We don't need to toggle isLoading here for the image visibility logic anymore
    });
  }

  // 2. Load Model Function
  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  // 3. Pick Image from Camera
  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      _image = File(image.path);
      _output = null; // Reset previous result
    });
    detectImage(_image!);
  }

  // 4. Pick Image from Gallery
  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _image = File(image.path);
      _output = null; // Reset previous result
    });
    detectImage(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 100),
            Text(
              'WELCOME TO',
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            SizedBox(height: 6),
            Text(
              'Cat and Dog Classifier',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            Center(
              // CHANGE: Logic now checks if _image is null, not isLoading
              child: _image == null
                  ? Container(
                      width: 400,
                      child: Column(
                        children: <Widget>[
                          // Ensure this matches the file name in your project folder!
                          // Based on your screenshot, it looked like 'cat_dog_icon.png'
                          Image.asset('assets/cat_dog_image.png'),
                          SizedBox(height: 50),
                        ],
                      ),
                    )
                  : Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 250,
                            child: Image.file(_image!), // Shows image immediately
                          ),
                          SizedBox(height: 20),
                          _output != null
                              ? Text(
                                  "${_output![0]['label']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  "Detecting...", // Shows this while TFLite runs
                                  style: TextStyle(
                                    color: Colors.grey, 
                                    fontSize: 18
                                  ), 
                                ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      pickImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 250,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Capture Image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      pickGalleryImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 250,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Select a Photo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}