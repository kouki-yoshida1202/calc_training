import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class TestScreen extends StatefulWidget {
  final numberOfQuestion;
  TestScreen({this.numberOfQuestion});
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int numberOfRemaining = 0;
  int numberOfCorrect = 0;
  int correctRate = 0;

  int questionLeft = 0;
  int questionRight = 0;
  String operator = "+";
  String answerString = "";

  Soundpool _soundpool;
  int soundIdCorrect = 0;
  int soundIdInCorrect = 0;

  bool isCalcButtonsEnabled = false;
  bool isAnswerCheckButtonEnabled = false;
  bool isBackButtonEnabled = false;
  bool isCorrectInCorrectImageEnabled = false;
  bool isEndMessageEnabled = false;
  bool isCorrect = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    numberOfCorrect = 0;
    correctRate = 0;
    numberOfRemaining = widget.numberOfQuestion;
    _initSounds();
    setQuestion();
  }

  void _initSounds() async {
    try {
      _soundpool = Soundpool();
      soundIdCorrect = await loadSound("assets/sounds/sound_correct.mp3");
      soundIdInCorrect = await loadSound("assets/sounds/sound_incorrect.mp3");
      setState(() {});
    } on IOException catch (error) {
      print("エラー$error");
    }
  }

  Future<int> loadSound(String soundPath) {
    return rootBundle.load(soundPath).then((value) => _soundpool.load(value));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _soundpool.release();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                _scorePart(),
                _questionPart(),
                _calcButtons(),
                _answerCheckButton(),
                _backButton(),
              ],
            ),
            _correctIncorrectImage(),
            _endMessage(),
          ],
        ),
      ),
    );
  }

  Widget _scorePart() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: 8.0,
      ),
      child: Table(
        children: [
          TableRow(
            children: [
              Center(
                child: Text(
                  "残り問題数",
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
              Center(
                child: Text(
                  "正解数",
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
              Center(
                child: Text(
                  "正答率",
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              Center(
                child: Text(
                  numberOfRemaining.toString(),
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Center(
                child: Text(
                  numberOfCorrect.toString(),
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Center(
                child: Text(
                  correctRate.toString(),
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _questionPart() {
    return Padding(
      padding: const EdgeInsets.only(top: 100, right: 8.0, left: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                questionLeft.toString(),
                style: TextStyle(fontSize: 36.0),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                operator,
                style: TextStyle(fontSize: 36.0),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                questionRight.toString(),
                style: TextStyle(fontSize: 36.0),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Center(
                  child: Text(
                "=",
                style: TextStyle(fontSize: 36.0),
              ))),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                answerString,
                style: TextStyle(fontSize: 36.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _calcButtons() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10,
          top: 60,
        ),
        child: Table(
          children: [
            TableRow(
              children: [
                _calcButton("7"),
                _calcButton("8"),
                _calcButton("9"),
              ],
            ),
            TableRow(
              children: [
                _calcButton("4"),
                _calcButton("5"),
                _calcButton("6"),
              ],
            ),
            TableRow(
              children: [
                _calcButton("1"),
                _calcButton("2"),
                _calcButton("3"),
              ],
            ),
            TableRow(
              children: [
                _calcButton("0"),
                _calcButton("-"),
                _calcButton("C"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _answerCheckButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          color: Colors.brown,
          onPressed: isCalcButtonsEnabled ? () => answerCheck() : null,
          child: Text(
            "こたえあわせ",
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }

  Widget _calcButton(String numString) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: RaisedButton(
        onPressed: isCalcButtonsEnabled ? () => inputAnswer(numString) : null,
        color: Colors.brown,
        child: Text(
          numString,
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }

  Widget _backButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: isBackButtonEnabled ? () => closeTestScreen() : null,
          child: Text(
            "もどる",
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }

  Widget _correctIncorrectImage() {
    if (isCorrectInCorrectImageEnabled == true) {
      if (isCorrect == true) {
        return Center(child: Image.asset("assets/images/pic_correct.png"));
      } else {
        return Center(child: Image.asset("assets/images/pic_incorrect.png"));
      }
    } else {
      return Container();
    }
  }

  Widget _endMessage() {
    if (isEndMessageEnabled == true) {
      return Center(
          child: Text(
        'テスト終了',
        style: TextStyle(fontSize: 60),
      ));
    } else {
      return Container();
    }
  }

  void setQuestion() {
    isCalcButtonsEnabled = true;
    isAnswerCheckButtonEnabled = true;
    isBackButtonEnabled = false;
    isCorrectInCorrectImageEnabled = false;
    isEndMessageEnabled = false;
    answerString = "";
    Random random = Random();
    questionLeft = random.nextInt(100) + 1;
    questionRight = random.nextInt(100) + 1;

    if (random.nextInt(2) + 1 == 1) {
      operator = "+";
    } else {
      operator = "-";
    }

    setState(() {});
  }

  inputAnswer(String numString) {
    setState(() {
      if (numString == "C") {
        answerString = "";
        return;
      }
      if (numString == "-") {
        if (answerString == "") {
          answerString = "-";
        }
        return;
      }

      if (numString == "0") {
        if (answerString != "0" && answerString != "-") {
          answerString = answerString + numString;
        }
        return;
      }

      if (answerString == "0") {
        answerString = numString;
        return;
      }
      answerString = answerString + numString;
    });
  }

  answerCheck() {
    if (answerString == "" || answerString == "-") {
      return;
    }
    isCalcButtonsEnabled = false;
    isAnswerCheckButtonEnabled = false;
    isBackButtonEnabled = false;
    isCorrectInCorrectImageEnabled = true;
    isEndMessageEnabled = false;

    numberOfRemaining -= 1;
    var myAnswer = int.parse(answerString).toInt();
    var realAnswer = 0;
    if (operator == "+") {
      realAnswer = questionLeft + questionRight;
    } else {
      realAnswer = questionLeft - questionRight;
    }
    if (myAnswer == realAnswer) {
      isCorrect = true;
      _soundpool.play(soundIdCorrect);
      numberOfCorrect += 1;
    } else {
      isCorrect = false;
      _soundpool.play(soundIdInCorrect);
    }

    correctRate =
        ((numberOfCorrect / (widget.numberOfQuestion - numberOfRemaining)) *
                100)
            .toInt();

    if (numberOfRemaining == 0) {
      // 残り問題数がないとき
      isCalcButtonsEnabled = false;
      isAnswerCheckButtonEnabled = false;
      isBackButtonEnabled = true;
      isCorrectInCorrectImageEnabled = true;
      isEndMessageEnabled = true;
    } else {
      Timer(Duration(seconds: 1), () {
        setQuestion();
      });
    }
    setState(() {});
  }

  closeTestScreen() {
    Navigator.pop(context);
  }
}
