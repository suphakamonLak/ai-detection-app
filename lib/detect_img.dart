import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_1/object_detection.dart';
import 'dart:io' show Platform;

class DetectImg extends StatefulWidget {
  const DetectImg({super.key});

  @override
  State<DetectImg> createState() => _DetectImgState();
}

class _DetectImgState extends State<DetectImg> {
  final imagePicker = ImagePicker();
  ObjectDetection? objectDetection;

  Uint8List? image;
  List<DetectionResult> detections = [];// เก็บผลการตรวจจับ

  @override
  void initState() {
    super.initState();
    objectDetection = ObjectDetection();
  }

  Future<void> _handleImage(String imagePath) async {
    final result = objectDetection!.analyseImage(imagePath);
    setState(() {
      image = result.imageBytes;
      detections = result.detections;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Object detection"),
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: (image != null) ? Image.memory(image!) : Text("Select Image for Detection"),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: detections.length,
                  itemBuilder: (context, index) {
                    final def = detections[index];
                    return ListTile(
                      leading: Icon(Icons.list, size: 30,),
                      title: Text('${def.label} ', style: TextStyle(color: Colors.black),),
                      subtitle: Text("Confidence: ${(def.confidence*100).toStringAsFixed(1)}%", style: TextStyle(color: Colors.black)),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context, 
                            builder: (_) => AlertDialog(
                              title: Text(def.label),
                              content: Text("Box: ${def.box.join(', ')}"),
                            )
                          );
                        }, 
                        icon: Icon(Icons.location_on_outlined, size: 30,)
                      ),
                    );
                  }
                )
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (Platform.isAndroid || Platform.isIOS)
                      IconButton(
                        onPressed: () async {
                          final result = await imagePicker.pickImage(
                            source: ImageSource.camera,
                          );
                          if (result != null) {
                            await _handleImage(result.path);
                          }
                        },
                        icon: const Icon(
                          Icons.camera,
                          size: 64,
                        ),
                      ),
                    IconButton(
                      onPressed: () async {
                        final result = await imagePicker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (result != null) {
                          await _handleImage(result.path);
                        }
                      },
                      icon: const Icon(
                        Icons.photo,
                        size: 64,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}