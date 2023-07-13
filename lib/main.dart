import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pomodoro_timer_app/view/timer_setting_screen.dart';

void main() {
  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pomodoro Timer",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PomodoroHomePage(
        title: "ポモドーロタイマー",
      ),
    );
  }
}

// SessionStatus: 作業中, 小休憩, 長休憩か状態を表す
enum SessionStatus { work, shortBreak, longBreak }

class PomodoroHomePage extends StatefulWidget {
  const PomodoroHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _PomodoroHomePageState createState() => _PomodoroHomePageState();
}

class _PomodoroHomePageState extends State<PomodoroHomePage> {
  int _workHours = 2; //合計時間
  int _longBreak = 15; //100分ごとの休憩
  int _timeRemaining = 25 * 60; //残り時間
  Timer? _timer; //スタートするまでnull

  int _studySessionCount = 0; //何回作業セッションが行われたかカウント
  SessionStatus _sessionStatus = SessionStatus.work; // 初期状態は作業中

  void _openSettings() async {
    //設定画面を開く
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TimerSettingScreen()),
    );

    //結果からそれを作業時間に設定する
    if (result is Map<String, int>) {
      setState(() {
        _workHours = result["workTime"] ?? _workHours;
        _longBreak = result["breakTime"] ?? _longBreak;
      });
    }
  }

  String get sessionLabel {
    switch (_sessionStatus) {
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

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          timer.cancel();
          _transitionSession();
        }
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _timeRemaining = 25 * 60;
      _sessionStatus = SessionStatus.work; //初期状態にリセット
    });
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  void _transitionSession() {
    _studySessionCount++;

    //4書いの作業セッションごとに長休憩にする
    if (_studySessionCount % 4 == 0) {
      _sessionStatus = SessionStatus.longBreak;
      _timeRemaining = _longBreak * 60;
    } else {
      _sessionStatus = _sessionStatus == SessionStatus.work
          ? SessionStatus.shortBreak
          : SessionStatus.work;

      _timeRemaining = _sessionStatus == SessionStatus.work ? 25 * 60 : 5 * 60;
    }

    _startTimer();
  }

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Timer Finished!"),
            actions: <Widget>[
              TextButton(
                  child: const Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _openSettings,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${(_timeRemaining ~/ 60).toString().padLeft(2, "0")}:${(_timeRemaining % 60).toString().padLeft(2, "0")}",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 50),
            Text("作業時間 : $_workHours"),
            Text("長休憩 : $_longBreak"),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  child: const Text("スタート"),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: const Text("リセット"),
                )
              ],
            ),
            const SizedBox(height: 50),
            Text(sessionLabel, style: Theme.of(context).textTheme.titleLarge)
          ],
        ),
      ),
    );
  }
}
