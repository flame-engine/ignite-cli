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

class MyGame extends FlameGame with TapCallbacks {
  late final MyComponent myComponent;

  @override
  Future<void> onLoad() async {
    await world.add(myComponent = MyComponent());
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    myComponent.speed.x = -1 + 2 * _rng.nextDouble();
    myComponent.speed.y = -1 + 2 * _rng.nextDouble();
  }
}

class MyComponent extends PositionComponent with HasGameRef<MyGame> {
  static final _paint = BasicPalette.white.paint();
  final Vector2 speed = Vector2.zero();

  MyComponent()
      : super(
          anchor: Anchor.center,
          size: Vector2.all(32),
        );

  @override
  void render(Canvas c) {
    c.drawRect(size.toRect(), _paint);
  }

  @override
  void update(double dt) {
    position += speed * 32.0 * dt;
  }
}
