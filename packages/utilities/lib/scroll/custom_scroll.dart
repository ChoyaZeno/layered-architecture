import 'dart:math';

import 'package:flutter/material.dart';

class PageViewScrollPhysics extends ScrollPhysics {
  const PageViewScrollPhysics({super.parent});

  @override
  PageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return PageViewScrollPhysics(parent: buildParent(ancestor));
  }

  // @override
  // double get dragStartDistanceMotionThreshold => 75;

  // @override
  // double get minFlingDistance => 75;

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      // Underscroll.
      return value - position.pixels;
    }
    // if (position.maxScrollExtent <= position.pixels &&
    //     position.pixels < value) {
    //   // Overscroll.
    //   return value - position.pixels;
    // }
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      // Hit top edge.
      return value - position.minScrollExtent;
    }
    // if (position.pixels < position.maxScrollExtent &&
    //     position.maxScrollExtent < value) {
    //   // Hit bottom edge.
    //   return value - position.maxScrollExtent;
    // }
    return 0.0;
  }
}

class OverScrollPhysics extends AlwaysScrollableScrollPhysics {
  const OverScrollPhysics({super.parent});

  ScrollMetrics expandScrollMetrics(ScrollMetrics position) {
    return FixedScrollMetrics(
      pixels: position.pixels,
      axisDirection: position.axisDirection,
      minScrollExtent: min(position.minScrollExtent, position.pixels),
      maxScrollExtent: position.viewportDimension + position.maxScrollExtent,
      viewportDimension: position.viewportDimension,
      devicePixelRatio: position.devicePixelRatio,
    );
  }

  @override
  OverScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return OverScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return super.applyPhysicsToUserOffset(
      expandScrollMetrics(position),
      offset,
    );
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return super.shouldAcceptUserOffset(expandScrollMetrics(position));
  }

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    return super.adjustPositionForNewDimensions(
      oldPosition: expandScrollMetrics(oldPosition),
      newPosition: expandScrollMetrics(newPosition),
      isScrolling: isScrolling,
      velocity: velocity,
    );
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    return super.applyBoundaryConditions(
      expandScrollMetrics(position),
      value,
    );
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    return super.createBallisticSimulation(
      expandScrollMetrics(position),
      velocity,
    );
  }
}
