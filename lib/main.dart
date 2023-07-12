import 'package:flutter/material.dart';

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
            Text('25:00',
              style: Theme.of(context).textTheme.headline1,),
            SizedBox(height: 50),
            Text("勉強時間 : $_studyHours"),
            Text("長休憩 : $_longBreak"),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () => {},
                    child: Text("スタート"),
                ),
                SizedBox(width: 30),
                ElevatedButton(onPressed: () => {},
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