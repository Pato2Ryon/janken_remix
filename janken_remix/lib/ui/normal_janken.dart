import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janken_remix/common/bubble.dart';
import 'package:janken_remix/common/janken_card.dart';

// final resultVisibleProvider = StateProvider((_) => false);
final resultVisibleProvider =
    ChangeNotifierProvider((_) => CustomVisibleNotifier());

enum Janken { gu, choki, pa }

extension JankenExtension on Janken {
  static final jankens = {Janken.gu: 0, Janken.choki: 1, Janken.pa: 2};

  static final imgs = {
    Janken.gu: 'assets/images/janken_gu.png',
    Janken.choki: 'assets/images/janken_choki.png',
    Janken.pa: 'assets/images/janken_pa.png'
  };
  int get poi => jankens[this];
  String get img => imgs[this];
}

class CustomVisibleNotifier extends ChangeNotifier {
  bool _resultVisible = false;
  bool get resultVisible => _resultVisible;
  set resultVisible(bool r) {
    _resultVisible = r;
    notifyListeners();
  }
}

class NormalJankenPage extends StatelessWidget {
  String _userHand = Janken.gu.img;
  String _enemyHand = Janken.gu.img;
  String _enemyImage = 'assets/images/amabie1_smile.png';
  String _serif = '';
  int _enemyChoice;
  int _result;
  int _second = 0;

  void _setJanken(BuildContext context, int userChoice) {
    _second = 300;
    var random = new math.Random();
    _enemyChoice = random.nextInt(2);
    _userHand = Janken.values[userChoice].img;
    _enemyHand = Janken.values[_enemyChoice].img;
    _result = (userChoice - _enemyChoice + 3) % 3;
    print(_result);
    if (_result == 0) {
      _serif = 'もう一回！';
      _enemyImage = 'assets/images/amabie1_smile.png';
    } else if (_result == 1) {
      _serif = '負けちゃった';
      _enemyImage = 'assets/images/amabie3_cry.png';
    } else {
      _serif = 'やったー！';
      _enemyImage = 'assets/images/amabie4_laugh.png';
    }
    context.read(resultVisibleProvider).resultVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ノーマルじゃんけん'),
      ),
      body: Stack(
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: Text(
                'じゃんけん',
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.orange.shade200,
                  fontFamily: 'HigashiOmeGothic',
                ),
              )),
          RaisedButton(
            child: const Text('Button'),
            color: Colors.orange,
            textColor: Colors.white,
            onPressed: () {
              _second = 0;
              _enemyImage = 'assets/images/amabie1_smile.png';
              context.read(resultVisibleProvider).resultVisible = false;
            },
          ),
          Center(
            child: _resultRow(context),
          ),
          Center(
            child: _jankenRow(context),
          ),
          _enemyRow(context),
        ],
      ),
    );
  }

  Consumer _jankenRow(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final visible = !watch(resultVisibleProvider).resultVisible;
      return Visibility(
          visible: visible,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              JankenCard(
                image: Janken.gu.img,
                onTap: () {
                  _setJanken(context, Janken.gu.poi);
                },
              ),
              JankenCard(
                image: Janken.choki.img,
                onTap: () {
                  _setJanken(context, Janken.choki.poi);
                },
              ),
              JankenCard(
                image: Janken.pa.img,
                onTap: () {
                  _setJanken(context, Janken.pa.poi);
                },
              ),
            ],
          ));
    });
  }

  Consumer _resultRow(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final visible = watch(resultVisibleProvider).resultVisible;
      return AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: _second),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 200,
                  child: Center(child: Text('YOU')),
                ),
                Container(
                  width: 200,
                  child: Center(child: Text('アマビエ')),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(5.0),
                  width: 200,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    _userHand,
                    width: 120,
                    height: 120,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  width: 200,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    _enemyHand,
                    width: 120,
                    height: 120,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Consumer _enemyRow(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final visible = watch(resultVisibleProvider).resultVisible;
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 200,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Opacity(
                opacity: visible ? 1.0 : 0.0,
                // visible: visible,
                child: Bubble(_serif, Color.fromARGB(255, 255, 150, 180)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('アマビエ'),
                  Image.asset(
                    _enemyImage,
                    width: 120,
                    height: 120,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
