import 'package:flutter/material.dart';

class CircularScrollPhysics extends ScrollPhysics {
  const CircularScrollPhysics({super.parent});

  @override
  CircularScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CircularScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels && position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    } else if (value > position.pixels && position.pixels >= position.maxScrollExtent) {
      return value - position.pixels;
    }
    return 0.0;
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    if (velocity.abs() < tolerance.velocity) {
      return null;
    }

    final double target = position.pixels + velocity;
    final double clampedTarget = target.clamp(position.minScrollExtent, position.maxScrollExtent);
    if (clampedTarget == target) {
      return super.createBallisticSimulation(position, velocity);
    }

    return ScrollSpringSimulation(
      spring,
      position.pixels,
      target,
      velocity,
      tolerance: tolerance,
    );
  }
}