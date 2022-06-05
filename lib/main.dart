// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

enum Face { front, back }

extension on Face {
  String get text {
    switch (this) {
      case Face.front:
        return 'Front';
      case Face.back:
        return 'Back';
    }
  }

  String get key => text;
  AssetImage get image {
    switch (this) {
      case Face.front:
        return const AssetImage('images/front.png');
      case Face.back:
        return const AssetImage('images/back.png');
    }
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final CardWidget frontWidget;
  late final CardWidget backWidget;

  bool _isShowingFront = true;

  @override
  void initState() {
    frontWidget = CardWidget(
      key: ValueKey(Face.front.key),
      face: Face.front,
      onTapped: () {
        setState(() => _isShowingFront = false);
      },
    );
    backWidget = CardWidget(
      key: ValueKey(Face.back.key),
      face: Face.back,
      onTapped: () {
        setState(() => _isShowingFront = true);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flip Animation'),
      ),
      body: switcherWidget(),
    );
  }

  Widget switcherWidget() {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: _isShowingFront ? 0.0 : pi),
      duration: Duration(seconds: 1),
      curve: Curves.linearToEaseOut,
      builder: (context, double value, child) {
        final isShowingBack = value > pi / 2.0; //pi= 180 degrees
        final toDisplay = isShowingBack ? backWidget : frontWidget;
        return Transform(
          transform: Matrix4.identity()
            ..scale(0.7, 0.7)
            ..rotateY(value),
          alignment: Alignment.center,
          child: Transform(
            transform: Matrix4.rotationY(isShowingBack ? pi : 0.0),
            alignment: Alignment.center,
            child: toDisplay,
          ),
        );
      },
    );
  }
}

class CardWidget extends StatelessWidget {
  final Face face;
  final VoidCallback onTapped;
  const CardWidget({
    Key? key,
    required this.face,
    required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue[300],
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0.0, 10.0),
              blurRadius: 40.0,
              spreadRadius: 2.0,
              color: Colors.black.withOpacity(0.4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: face.image,
              ),
              Text(
                face.text,
                style: TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(0.0, 3.0),
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
