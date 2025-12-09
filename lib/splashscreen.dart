import 'package:flutter/material.dart';
import 'package:cat_dog_classifier/home.dart';

class MySplash extends StatefulWidget {
  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Home()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/cat_dog_image.png", height: 120),
            SizedBox(height: 20),
            Text(
              "Cat and Dog Classifier",
              style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
