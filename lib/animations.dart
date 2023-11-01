import 'package:flutter/animation.dart';
import 'package:flutter_animate/flutter_animate.dart';

const _duration = Duration(milliseconds: 400);
final double animationInterval = _duration.inMilliseconds / 2;

final characterDetailsWidgetLoadEffects = <Effect<dynamic>>[
  const SlideEffect(
      duration: _duration,
      begin: Offset(.5, 0),
      end: Offset.zero,
      curve: Curves.linear),
  const FadeEffect(
    duration: _duration,
  ),
];
