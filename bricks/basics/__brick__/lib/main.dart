import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

final _rng = Random();

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyComponent extends PositionComponent with HasGameRef<MyGame> {
  static final _paint = BasicPalette.white.paint();
  final Vector2 speed = Vector2.zero();

  @override
  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
    position = gameRef.size / 2;
  }

  @override
  void render(Canvas c) {
    c.drawRect(size.toRect(), _paint);
  }

  @override
  void update(double dt) {
    position += speed * dt;
  }
}

class MyGame extends FlameGame with TapDetector {
  late final MyComponent myComponent;

  @override
  Future<void> onLoad() async {
    await add(myComponent = MyComponent());
    return super.onLoad();
  }

  @override
  void onTap() {
    myComponent.speed.x = -5 + 10 * _rng.nextDouble();
    myComponent.speed.y = -5 + 10 * _rng.nextDouble();
  }
}
