import 'package:flutter/material.dart';

import './clothes_question.dart';
import './clothes_answer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;
  var questions = [
    {
      'question':'Select clothing season',
      'answer':[
        'Winter',
        'Spring',
        'Summer',
        'Autumn',
      ]
    },
    {
      'question':'Select clothing brand',
      'answer':[
        'Adidas',
        'Nike',
        'Puma',
        'Zara',
      ]
    },
    {
      'question':'Select clothing type',
      'answer':[
        'T-Shirt',
        'Coat',
        'Blouse',
        'Socks',
      ]
    },
  ];


  void _iWasTapped(){
    setState(() {
      if(_questionIndex > 1) {
        _questionIndex = 0;
      }
      else {
        _questionIndex += 1;
      }
    });
    print("I was tapped");
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Lab 2 - 193087',
        home: Scaffold(
            appBar: AppBar(
              title: Text("Lab2_193087"),
            ),
            body: Column(
                children: [
                  ClothesQuestion(questions[_questionIndex]['question'] as String),
                  ...(questions[_questionIndex]['answer'] as List<String>).map((answer) => ClothesAnswer(_iWasTapped, answer)),
                ]
            )
        )
    );
  }
}
