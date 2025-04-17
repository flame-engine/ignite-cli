import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

final _rng = Random();

void main() {
  runApp(const GameWidget.controlled(gameFactory: MyGame.new));
}

class MyGame extends FlameGame<MyWorld> {
  MyGame() : super(world: MyWorld());
}

class MyWorld extends World {
  late final MyComponent myComponent;

  @override
  Future<void> onLoad() async {
    await add(myComponent = MyComponent());
    return super.onLoad();
  }
}

class MyComponent extends RectangleComponent with TapCallbacks {
  final Vector2 speed = Vector2.zero();

  MyComponent()
      : super.square(
          size: 64,
          anchor: Anchor.center,
          paint: BasicPalette.magenta.paint(),
        );

  @override
  void update(double dt) {
    position += speed * 128.0 * dt;
  }

  @override
  void onTapDown(TapDownEvent event) {
    speed.x = -1 + 2 * _rng.nextDouble();
    speed.y = -1 + 2 * _rng.nextDouble();
  }
}
