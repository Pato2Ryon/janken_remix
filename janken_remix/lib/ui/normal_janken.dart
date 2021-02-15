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
  String _image = Janken.gu.img;
  String _enemyImage = Janken.gu.img;
  int _enemyChoice;
  int _result;

  void setJanken(int userChoice) {
    var random = new math.Random();
    _enemyChoice = random.nextInt(2);
    _enemyImage = Janken.values[_enemyChoice].img;
    _result = (userChoice - _enemyChoice + 3) % 3;
    print(_result);
    if (_result == 0) {
      print("アイコ");
    } else if (_result == 1) {
      print("負け");
    } else {
      print("勝ち");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ノーマルじゃんけん'),
      ),
      body: Stack(
        children: [
          // if (context.read(resultVisibleProvider).resultVisible)
          //   Container(
          //     child: Text('aaaa'),
          //   ),
          Align(
              alignment: Alignment.topCenter,
              child: Text(
                'じゃんけん',
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.orange.shade200,
                  fontFamily: "HigashiOmeGothic",
                ),
              )),
          RaisedButton(
            child: const Text('Button'),
            color: Colors.orange,
            textColor: Colors.white,
            onPressed: () {
              // context.read(cardVisibleProvider).resultVisible = false;
              context.read(resultVisibleProvider).resultVisible = false;
            },
          ),
          Center(
            child: JankenRow(context),
          ),
          Center(
            child: ResultRow(context),
          ),
          Consumer(builder: (context, watch, child) {
            return Container(
              child: Align(
                alignment: Alignment(0, 0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Bubble('あああああああああああああああああああ',
                        Color.fromARGB(255, 255, 150, 180)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/images/amabie1_smile.png',
                          width: 120,
                          height: 120,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Consumer JankenRow(BuildContext context) {
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
                  _image = Janken.gu.img;
                  setJanken(Janken.gu.poi);
                  context.read(resultVisibleProvider).resultVisible = true;
                },
              ),
              JankenCard(
                image: Janken.choki.img,
                onTap: () {
                  _image = Janken.choki.img;
                  setJanken(Janken.choki.poi);
                  context.read(resultVisibleProvider).resultVisible = true;
                },
              ),
              JankenCard(
                image: Janken.pa.img,
                onTap: () {
                  _image = Janken.pa.img;
                  setJanken(Janken.pa.poi);
                  context.read(resultVisibleProvider).resultVisible = true;
                },
              ),
            ],
          ));
    });
  }

  Consumer ResultRow(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final visible = watch(resultVisibleProvider).resultVisible;
      return Visibility(
        visible: visible,
        child: Row(
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
                _image,
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
                _enemyImage,
                width: 120,
                height: 120,
              ),
            ),
          ],
        ),
      );
    });
  }
}
