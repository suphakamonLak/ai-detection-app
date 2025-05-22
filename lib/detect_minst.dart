import 'package:ai_1/draw.dart';
import 'package:flutter/rendering.dart';
import 'mnist.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MyMinst extends StatefulWidget {
  final title;

  const MyMinst({super.key, required this.title});

  @override
  State<MyMinst> createState() => _MyMinstState();
}

class _MyMinstState extends State<MyMinst> {
  List<Offset?> _points = <Offset?>[];// เก็บพิกัดของจุดที่ผู้ใช้วาด
  final GlobalKey _globalKey = GlobalKey();// ใช้เก็บ Key ของ RepaintBoundary เพื่อจับภาพ
  late Mnist _mnist;// อินสแตนซ์ของ Mnist ที่ใช้สำหรับประมวลผลภาพ
  int? _predictNumber;// ค่าที่โมเดลคาดการณ์
  late double _predictConfidence;// ค่าความมั่นใจของโมเดล
  int _inferenceTime = 0;// เวลาที่ใช้ในการทำ Inference

  @override
  void initState() {// โหลดโมเดล MNIST ก่อนที่ UI จะถูกสร้างขึ้น
    _mnist = Mnist();
    _mnist.init();
    super.initState();
  }

  Future<void> predictNumber() async {// predict
    // capture sketch area
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;//  เพื่อจับภาพพื้นที่วาด
    ui.Image image = await boundary.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      print("ไม่สามารถแปลงภาพเป็น ByteData ได้");
      return;
    }
    final inputImageData = byteData.buffer.asUint8List();
    final stopwatch = Stopwatch()..start();
    final (number, confidence) = await _mnist.runInference(inputImageData!);// predict

    setState(() {
      _predictNumber = number;
      _predictConfidence = confidence;
      _inferenceTime = stopwatch.elapsedMilliseconds;
    });
    print("Predict: $_predictNumber (${_predictConfidence?.toStringAsFixed(3)} %)");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromARGB(255, 219, 180, 255),
      ),
      body: Center(
        child: Column(
          children: [
            AspectRatio(aspectRatio: 1, child: drawArea()),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Spacer(),
                    const Text("Predict number: "),
                    if (_predictNumber != null)
                      Text(
                        "$_predictNumber (${(_predictConfidence * 100).toStringAsFixed(1)} %)",
                      ),
                    Spacer(),
                    Text("Inteference Time: $_inferenceTime ms"),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _points = [];
                            _predictNumber = 0;
                            _predictConfidence = 0.0;
                          });
                        },
                        child: Text("clear"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawArea() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            Offset point = details.localPosition;

            double x = point.dx.clamp(0, width);
            double y = point.dx.clamp(0, height);

            setState(() {
              _points = List.from(_points)..add(point);
            });
          },
          onPanEnd: (DragEndDetails details) async {
            setState(() {
              _points.add(null);// เพิ่ม null เพื่อปิดเส้น
            });
            await predictNumber();// เรียก predict เมื่อวาดเสร็จ
          },
          child: RepaintBoundary(
            key: _globalKey,
            child: Container(
              color: Colors.black,
              child: CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: Draw(_points),
              ),
            ),
          ),
        );
      },
    );
  }
}