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
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
                Text("Object detection", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                Container(
                width: 100,
                height: 100,
                child: Image.asset('assets/img/detect.png'),
              ),
            ],
          ),
        ),
        toolbarHeight: 100,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: (image != null) 
                  ? Image.memory(image!) 
                  : Padding(
                    padding: const EdgeInsets.only(top: 20, left: 30),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 60, 98, 163),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Welcome to AI Detection!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                            Text("you can select Image or Camera for Detection\nI hope you will happy...", style: TextStyle(fontSize: 16, color: Colors.white),),
                            SizedBox(height: 20,),
                            Row(
                              children: [
                                Icon(Icons.star, color: const Color.fromARGB(255, 242, 242, 126),),
                                Icon(Icons.star, color: const Color.fromARGB(255, 242, 242, 126),),
                                Icon(Icons.star, color: const Color.fromARGB(255, 242, 242, 126),),
                                Icon(Icons.star, color: const Color.fromARGB(255, 242, 242, 126),),
                                Icon(Icons.star, color: const Color.fromARGB(255, 242, 242, 126),),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: detections.length,
                  itemBuilder: (context, index) {
                    final def = detections[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 3,
                        color: const Color.fromARGB(255, 177, 203, 249),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            ListTile(
                              title: Text('${def.label} ', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
                              subtitle: Text("Confidence: ${(def.confidence*100).toStringAsFixed(1)}%", style: TextStyle(color: Colors.black, fontSize: 16)),
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
                                icon: Icon(Icons.location_on_outlined, size: 30, color: Colors.black,)
                              ),
                              // tileColor: const Color.fromARGB(255, 177, 203, 249),
                            ),
                          ],
                        ),
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