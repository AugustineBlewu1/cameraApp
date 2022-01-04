import 'dart:io';

import 'package:flutter/material.dart';

class GalleryScrren extends StatelessWidget {
  final List<File> images;
  const GalleryScrren({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: const Text('Gallery Images'),),
      body: GridView.count(crossAxisCount: 3, mainAxisSpacing: 2, crossAxisSpacing: 2,
      children: images.map((e) => Image.file(e, fit: BoxFit.cover,)).toList(),),
    );
  }
}
