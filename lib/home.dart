import 'package:ai_1/detect_img.dart';
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
      appBar: AppBar(
        title: Text("Ai Detection"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Welcome to using Ai Detection!", style: TextStyle(fontSize: 16),),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                }, 
                child: Text("Detect Number")
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => DetectImg()));
                }, 
                child: Text("Detect Image")
              )
            ],
          )
        ],
      ),
    );
  }
}