import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

class HardSpringPageViewScrollPhysics extends ScrollPhysics {
  const HardSpringPageViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  HardSpringPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return HardSpringPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 150,
    stiffness: 100,
    damping: 0.8,
  );
}