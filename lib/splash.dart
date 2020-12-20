import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'main.dart';
class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class One extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Splash(),
    );
  }
}

class _SplashState extends State<Splash>with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    wait();
    _controller = AnimationController(vsync: this);
  }

  wait()async{
    await new Future.delayed(const Duration(seconds : 5));
    runApp(Two());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Center(
          child: Lottie.asset(
            'assets/cam.json',
            controller: _controller,
            onLoaded: (composition) {
              // Configure the AnimationController with the duration of the
              // Lottie file and start the animation.
              _controller
                ..duration = composition.duration
                ..forward();
            },
          ),
        ),
      ),
    );
  }
}


class Two extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Unsplash(),
    );
  }
}