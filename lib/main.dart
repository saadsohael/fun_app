import 'dart:ffi';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Center(child: Text("The Big Brain")),
        backgroundColor: Colors.blue.shade900,
      ),
      body: AppBody(),
    ),
  ));
}

class AppBody extends StatefulWidget {
  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  String question = "Who is the richest person on earth?";
  String answer = "";
  String imgSource = "images/unknown.jpeg";
  int revealed = 0;
  int question_asked = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
          SizedBox(
            height: 120.0,
          ),
          CircleAvatar(
            foregroundImage: AssetImage(imgSource),
            radius: 100.0,
          ),
          SizedBox(
            height: 40.0,
          ),
          Text(
            answer,
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (revealed == 0 && question_asked == 1) {
                  imgSource = "images/richest.jpg";
                  answer = "It is Bernard Arnault";
                  revealed = 1;
                } else if (revealed == 0 && question_asked == 2) {
                  imgSource = "images/tallest.jpg";
                  answer = "It is Sutlan Kosen";
                  revealed = 1;
                } else if (revealed == 0 && question_asked == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute()),
                  );
                }
              });
            },
            child: Text(
              "Reveal",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (revealed == 1 && question_asked == 1) {
                  question = "Who is the tallest person?";
                  imgSource = "images/unknown.jpeg";
                  answer = "";
                  revealed = 0;
                  question_asked = 2;
                } else if (revealed == 1 && question_asked == 2) {
                  question = "Who is the laziest person?";
                  imgSource = "images/unknown.jpeg";
                  answer = "";
                  revealed = 0;
                  question_asked = 3;
                }
              });
            },
            child: Text(
              "Next",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondRoute extends StatefulWidget {
  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[1], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
          title: const Center(child: Text("The Big Brain")),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(
            "It's You Bitch!",
            style: TextStyle(fontSize: 24.0),
          ),
          Expanded(child: CameraPreview(controller)),
        ]));
  }
}

class MyClipper extends CustomClipper<Rect> {
  Rect getClip(size) {
    return Rect.fromLTWH(70, 250, 220.0, 220.0);
  }

  bool shouldReclip(oldClipper) {
    return true;
  }
}
