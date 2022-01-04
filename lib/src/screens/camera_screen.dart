import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_app/src/screens/gallery_screen.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> camera;
  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> intializeController;
  int selectCamera = 0;
  List<File> capturedImages = [];

  @override
  void initState() {
    initializeCamera(selectCamera);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
              future: intializeController,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          // const Spacer(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: iconButton,
                    icon: const Icon(
                      Icons.switch_camera_outlined,
                      color: Colors.black,
                    )),
                GestureDetector(
                  onTap: () async {
                    await intializeController;
                    var xFile = await _controller.takePicture();
                    setState(() {
                      capturedImages.add(File(xFile.path));
                    });
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (capturedImages.isEmpty) return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => GalleryScrren(images: capturedImages.reversed.toList(),)));
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration:  BoxDecoration(
                        border: Border.all(color: Colors.black),
                        image: capturedImages.isNotEmpty ? DecorationImage(image: FileImage(capturedImages.last), fit: BoxFit.cover) : null),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  initializeCamera(int cameraIndex) async {
    _controller =
        CameraController(widget.camera[cameraIndex], ResolutionPreset.medium);

    intializeController = _controller.initialize();
  }

  iconButton() {
    if (widget.camera.length > 1) {
      setState(() {
        selectCamera = selectCamera == 0 ? 1 : 0;
        initializeCamera(selectCamera);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No secondary Camera found'),
        duration: Duration(seconds: 3),
      ));
    }
  }
}
