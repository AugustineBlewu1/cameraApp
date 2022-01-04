import 'package:camera/camera.dart';
import 'package:camera_app/src/app.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  runApp( MyApp(
    cameras: cameras,
  ));
}
