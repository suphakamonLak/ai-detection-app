import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class ObjectDetection {
  static const String _modelPath = 'assets/models/ssd_mobilenet.tflite';
  static const String _labelPath = 'assets/models/labelmap.txt';

  Interpreter? _interpreter;// using run model
  List<String>? _labels;

  ObjectDetection() {
    _loadModel();
    _loadLabels();
    log('Done.');
  }

  Future<void> _loadModel() async {
    log('Loading interpreter options...');
    final interpreterOptions = InterpreterOptions();

    // Use XNNPACK Delegate (performance)
    if (Platform.isAndroid) {
      interpreterOptions.addDelegate(XNNPackDelegate());
    }

    // Use Metal Delegate
    if (Platform.isIOS) {
      interpreterOptions.addDelegate(GpuDelegate());
    }

    log('Loading interpreter...');
    _interpreter =
        await Interpreter.fromAsset(_modelPath, options: interpreterOptions);
  }

  Future<void> _loadLabels() async {
    log('Loading labels...');
    final labelsRaw = await rootBundle.loadString(_labelPath);
    _labels = labelsRaw.split('\n');
  }

  ImageDetectionOutput analyseImage(String imagePath) {
    log('Analysing image...');
    // Reading image bytes from file
    final imageData = File(imagePath).readAsBytesSync();

    // Decoding image
    final image = img.decodeImage(imageData);

    // Resizing image fpr model, [300, 300]
    final imageInput = img.copyResize(
      image!,
      width: 300,
      height: 300,
    );

    // Creating matrix representation, [300, 300, 3] โดยดึงค่า R, G, B ออกจากแต่ละพิกเซล
    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        },
      ),
    );

    final output = _runInference(imageMatrix);// เรียกใช้งาน model โดยส่ง input เข้า _runInference

    log('Processing outputs...');
    // 1. Location
    final locationsRaw = output[0][0] as List<List<double>>;

    // 2. Classes (ค่าคลาสของวัตถุแต่ละชนิด)
    final classesRaw = output[1][0] as List<double>;

    // 3. Scores (confident)
    final scores = output[2][0] as List<double>;

    // 4. Number of detections (จำนวนวัตถุที่ตรวจจับได้)
    final numberOfDetectionsRaw = (output[3][0] as double).toInt();
    final numberOfDetections = numberOfDetectionsRaw.toInt();
 
    final List<DetectionResult> detectionResults = [];

    log('Outlining objects...');
    final dataDetection = [];
    for (var i = 0; i < numberOfDetections; i++) {
      if (scores[i] > 0.6) {// แสดงเฉพาะคลาสที่มีค่า confident มากกว่า 60%
        final label = _labels![classesRaw[i].toInt()];
        final confidence = scores[i];
        final location = locationsRaw[i].map((v) => (v*300).toInt()).toList();
        
        // วาดกล่องและ label บนรูป
        img.drawRect(
          imageInput,
          x1: location[1],
          y1: location[0],
          x2: location[3],
          y2: location[2],
          color: img.ColorRgb8(255, 0, 0),
          thickness: 3,
        );

        // Label drawing
        img.drawString(
          imageInput,
          '$label ${(confidence * 100).toStringAsFixed(1)} %',
          font: img.arial14,
          x: location[1] + 1,
          y: location[0] + 1,
          color: img.ColorRgb8(255, 0, 0),
        );

        detectionResults.add(DetectionResult(
          label: label, 
          confidence: confidence, 
          box: location)
        );
      }
    }

    log('Done.');

    return ImageDetectionOutput(
      imageBytes: img.encodeJpg(imageInput), 
      detections: detectionResults,
    );
  }

  List<List<Object>> _runInference(List<List<List<num>>> imageMatrix) {
    log('Running inference...');

    // Set input tensor [1, 300, 300, 3]
    final input = [imageMatrix];

    final output = {// dictioinary สำหรับเก็บผลลัพธ์
      0: [List<List<num>>.filled(10, List<num>.filled(4, 0))],// Bounding boxes (x1, y1, x2, y2)
      1: [List<num>.filled(10, 0)],// class index
      2: [List<num>.filled(10, 0)],// confidence 
      3: [0.0],// จำนวนวัตถุที่ตรวจจับเจอ
    };

    _interpreter!.runForMultipleInputs([input], output);// run model และเก็บผลลัพธ์ใน output
    return output.values.toList();// แปลง Map เป็น List
  }

}

class DetectionResult {
  final String label;
  final double confidence;
  final List<int> box;// [top,left,bottom, right]

  DetectionResult({
    required this.label,
    required this.confidence,
    required this.box,
  });
}

class ImageDetectionOutput {
  final Uint8List imageBytes;
  final List<DetectionResult> detections;

  ImageDetectionOutput({
    required this.imageBytes,
    required this.detections,
  });
}