import 'package:flutter/material.dart';

import 'test_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DropdownMenuItem<int>> _menuItems = List();
  int _numberOfQuestions = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setMenuItems();
    _numberOfQuestions = _menuItems[0].value;
  }

  void setMenuItems() {
    _menuItems
      ..add(DropdownMenuItem(
        value: 10,
        child: Text(10.toString()),
      ))
      ..add(DropdownMenuItem(
        value: 20,
        child: Text(20.toString()),
      ))
      ..add(DropdownMenuItem(
        value: 30,
        child: Text(30.toString()),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Image.asset("assets/images/image_title.png"),
                SizedBox(
                  height: 50.0,
                ),
                Text("問題数を選択して「スタート」ボタンを押してください"),
                SizedBox(
                  height: 50.0,
                ),
                DropdownButton(
                  items: _menuItems,
                  value: _numberOfQuestions,
                  onChanged: (value) {
                    setState(() {
                      _numberOfQuestions = value;
                    });
                  },
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: RaisedButton.icon(
                      onPressed: () {
                        startTestScreen(context);
                      },
                      label: Text("スタート"),
                      icon: Icon(Icons.skip_next),
                      color: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void startTestScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TestScreen(
                  numberOfQuestion: _numberOfQuestions,
                )));
  }
}
