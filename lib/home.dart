import 'package:ai_1/detect_img.dart';
import 'package:ai_1/detect_minst.dart';
import 'package:flutter/material.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 196, 216, 222),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 196, 216, 222),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(255, 255, 255, 255)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Welcome to using Ai Detection!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        SizedBox(height: 5,),
                        Text("Please select what you'd like to detect:\nby image or by camera, and choose the object number you want to detect."),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 80,
                              child: Image.asset('assets/img/detect-banner.png'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      )
                    ),
                    onPressed: () {
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => MyMinst(title: "Detection number")));
                    }, 
                    child: Text("Detect Number", style: TextStyle(color:Colors.white),)
                  ),
                  SizedBox(width: 5,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 109, 156, 237),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      )
                    ),
                    onPressed: () {
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => DetectImg()));
                    }, 
                    child: Text("Detect Image", style: TextStyle(color: Colors.white),)
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}