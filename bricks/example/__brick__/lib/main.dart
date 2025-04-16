import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

final _rng = Random();

void main() {
  runApp(GameWidget(game: MyGame()));
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

  @override
  final Paint paint = BasicPalette.magenta.paint();

  MyComponent()
      : super.square(
          size: 32,
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    position += speed * 32.0 * dt;
  }

  @override
  void onTapUp(TapUpEvent event) {
    speed.x = -1 + 2 * _rng.nextDouble();
    speed.y = -1 + 2 * _rng.nextDouble();
  }
}
