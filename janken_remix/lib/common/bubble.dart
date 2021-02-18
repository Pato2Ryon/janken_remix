import 'package:flutter/material.dart';

class Bubble extends StatelessWidget {
  final String text;
  final Color color;

  Bubble(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Container(
      width: deviceSize.width * 2 / 3,
      height: deviceSize.height / 9,
      decoration: ShapeDecoration(
        color: color,
        shadows: [
          const BoxShadow(
            color: Color(0x80000000),
            offset: Offset(0, 2),
            blurRadius: 2,
          )
        ],
        shape: BubbleBorder(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Text(text)),
        ],
      ),
    );
  }
}

class BubbleBorder extends ShapeBorder {
  final bool usePadding;

  const BubbleBorder({this.usePadding = true});

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: usePadding ? 12 : 0);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) => null;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    final r =
        Rect.fromPoints(rect.topLeft, rect.bottomRight - const Offset(0, 12));
    return Path()
      ..addRRect(RRect.fromRectAndRadius(r, Radius.circular(8)))
      ..moveTo(r.topRight.dx, r.topRight.dy + (r.height / 2))
      ..relativeLineTo(0, -10)
      ..relativeLineTo(20, 10)
      ..relativeLineTo(-20, 10)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
