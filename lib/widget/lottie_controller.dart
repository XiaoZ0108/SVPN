import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieController extends StatefulWidget {
  const LottieController({
    super.key,
    required this.ratio,
    this.type = false,
    required this.name,
  });
  final bool type;
  final String name;
  final double ratio;
  @override
  LottieControllerState createState() => LottieControllerState();
}

class LottieControllerState extends State<LottieController>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Lottie.asset(
      'assets/animation/${widget.name}.json',
      frameRate: FrameRate.max,
      height: screenHeight * widget.ratio,
      controller: widget.type ? null : _controller,
      onLoaded: widget.type
          ? null
          : (composition) {
              _controller
                ..duration = composition.duration
                ..forward();
            },
    );
  }
}
