import 'package:tflite_flutter/tflite_flutter.dart';// โหลดและรันโมเดล TensorFlow Lite
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;// ใช้ทำ image processing

class Mnist {
  static const _modelPath = "assets/models/mnist.tflite";

  late Interpreter _interpreter;// ใช้โหลดและรันโมเดล
  late Tensor _inputTensor;
  late Tensor _outputTensor;

  Future<void> init() async {
    await _loadModel();
  }

  Future<void> _loadModel() async {// โหลดโมเดล
    final options = InterpreterOptions();
    // load model from assets
    _interpreter = await Interpreter.fromAsset(_modelPath, options: options);// โหลดโมเดลจากไฟล์ที่อยู่ใน assets
    _inputTensor = _interpreter.getInputTensors().first;
    _outputTensor = _interpreter.getOutputTensors().first;
  }

  Future<(int, double)> runInference(Uint8List inputImageData) async {// predict number from img input
    // resize image
    img.Image? image = img.decodeImage(inputImageData);
    img.Image? resizedImage = img.copyResize(
      image!,
      width: _inputTensor.shape[1],
      height: _inputTensor.shape[2],
    );

    // prepare input (แปลงภาพเป็นอาร์เรย์)
    final imageMatrix = List.generate(
      resizedImage.height,
      (y) => List.generate(resizedImage.width, (x) {
        final pixel = resizedImage.getPixel(x, y);// อ่านค่าพิกเซลของภาพ
        // แปลงให้เป็นค่าระหว่าง 0.0 ถึง 1.0
        return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
      }),
    );

    final input = [imageMatrix];// อาร์เรย์ที่เก็บค่าพิกเซลของภาพ
    final output = [List<double>.filled(_outputTensor.shape[1], 0.0)];// ความน่าจะเป็นของตัวเลข 0-9

    _interpreter.run(input, output);// รันโมเดล
    List<double> result = output.first;// ผลลัพธ์ที่โมเดลทำนาย

    // หาค่าที่มีความน่าจะเป็นสูงสุด
    int predictNumber = 0;// ค่าที่โมเดลคิดว่าเป็นตัวเลขที่ถูกต้อง
    double maxConfidence = result[0];// ค่าความมั่นใจ
    for (var i = 1; i < result.length; i++) {
      if (result[i] > maxConfidence) {
        maxConfidence = result[i];
        predictNumber = i;
      }
    }
    return (predictNumber, maxConfidence);
  }
}
