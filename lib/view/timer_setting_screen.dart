import 'package:flutter/material.dart';

class TimerSettingScreen extends StatefulWidget {
  TimerSettingScreen({Key? key}) : super(key: key);

  @override
  _TimerSettingScreenState createState() => _TimerSettingScreenState();
}

class _TimerSettingScreenState extends State<TimerSettingScreen> {
  double _currentSliderValue = 15; //長休憩時間の初期状態
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("設定"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "作業時間を設定してください",
              style: Theme.of(context).textTheme.headline6,
            ),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
            ),
            Text(
              "長休憩時間を設定してください",
              style: Theme.of(context).textTheme.headline6,
            ),
            Slider(
              value: _currentSliderValue,
              min: 15,
              max: 30,
              divisions: 15,
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                int? workTime = int.tryParse(_controller.text);
                if (workTime != null) {
                  //前の画面に設定された時間を返す
                  Navigator.pop(context, {
                    "workTime": workTime,
                    "breakTime": _currentSliderValue.round()
                  });
                } else {
                  //無効な場合のエラー
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("無効な入力です。再度入力してください。"),
                  ));
                }
              }, //ボタン押された時の動作
              child: Text("設定"),
            )
          ],
        ),
      ),
    );
  }
}
