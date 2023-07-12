import 'package:flutter/material.dart';
import 'dart:async';

void main(){
  runApp(PomodoroApp());
}

class PomodoroApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Pomodoro Timer",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PomodoroHomePage(title: "ポモドーロタイマー",),
    );
  }
}

class PomodoroHomePage extends StatefulWidget{
  PomodoroHomePage({Key? key, required this.title}) : super(key : key);
  final String title;

  @override
  _PomodoroHomePageState createState() => _PomodoroHomePageState();
}

class _PomodoroHomePageState extends State<PomodoroHomePage>{
  int _studyHours = 2;  //合計時間
  int _longBreak = 15;  //100分ごとの休憩
  int _timeRemaining = 25 * 60; //
  Timer? _timer;  //スタートするまでnull

  void _startTimer(){
    if(_timer != null){
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if(_timeRemaining > 0){
          _timeRemaining--;
        }else{
          timer.cancel();
          _showAlert(context);
        }
      });
    });
  }

  void _resetTimer(){
    setState(() {
      _timeRemaining = 25 * 60;
    });
    if(_timer != null){
      _timer!.cancel();
      _timer = null;
    }
  }

  void _showAlert(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Timer Finished!"),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
                onPressed: (){
                  Navigator.of(context).pop();
                }
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${(_timeRemaining ~/ 60).toString().padLeft(2, "0")}:${(_timeRemaining % 60).toString().padLeft(2, "0")}",
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: 50),
            Text("勉強時間 : $_studyHours"),
            Text("長休憩 : $_longBreak"),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: _startTimer,
                    child: Text("スタート"),
                ),
                SizedBox(width: 30),
                ElevatedButton(onPressed: _resetTimer,
                    child: Text("リセット"),
                )
              ],
            ),
            SizedBox(height: 50),
            Text("作業セッション中",style: Theme.of(context).textTheme.headline6)
          ],
        ),
      ),
    );
  }
}