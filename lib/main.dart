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
// SessionStatus: 作業中, 小休憩, 長休憩か状態を表す
enum SessionStatus { work, shortBreak, longBreak }

class PomodoroHomePage extends StatefulWidget{
  PomodoroHomePage({Key? key, required this.title}) : super(key : key);
  final String title;

  @override
  _PomodoroHomePageState createState() => _PomodoroHomePageState();
}

class _PomodoroHomePageState extends State<PomodoroHomePage>{
  int _studyHours = 2;  //合計時間
  int _longBreak = 15;  //100分ごとの休憩
  int _timeRemaining = 1 * 60; //残り時間
  Timer? _timer;  //スタートするまでnull

  int _studySessionCount = 0; //何回作業セッションが行われたかカウント
  SessionStatus _sessionStatus = SessionStatus.work; // 初期状態は作業中

  String get sessionLabel{
    switch(_sessionStatus){
      case SessionStatus.work:
        return "作業セッション中";
      case SessionStatus.shortBreak:
        return "小休憩中";
      case SessionStatus.longBreak:
        return "長休憩中";
      default:
        return "";
    }
  }

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
          _transitionSession();
        }
      });
    });
  }

  void _resetTimer(){
    setState(() {
      _timeRemaining = 25 * 60;
      _sessionStatus = SessionStatus.work; //初期状態にリセット
    });
    if(_timer != null){
      _timer!.cancel();
      _timer = null;
    }
  }

  void _transitionSession(){
    _studySessionCount++;

    //100分ごとに長休憩にする
    if(_studySessionCount % 4 == 0){
      _sessionStatus = SessionStatus.longBreak;
      _timeRemaining = _longBreak * 60;
    }else{
      _sessionStatus = _sessionStatus ==SessionStatus.work
          ? SessionStatus.shortBreak
          : SessionStatus.work;

      _timeRemaining = _sessionStatus == SessionStatus.work
          ? 25 * 60
          : 5 * 60;
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
            Text(sessionLabel,style: Theme.of(context).textTheme.headline6)
          ],
        ),
      ),
    );
  }
}