import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class ar extends StatefulWidget {
  @override
  _ar createState() => _ar();
}

class _ar extends State<ar> {
  late List<CameraDescription> cameras;
  late CameraController controller;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    _askPermission();
    initializeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _askPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    }
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    await controller.initialize();
    setState(() {
      isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caméra'),
      ),
      body: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Prendre une photo'),
            onPressed: () async {
              try {
                XFile image = await controller.takePicture();
                // Faire quelque chose avec l'image capturée
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      ),
    );
  }
}