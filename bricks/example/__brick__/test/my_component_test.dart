import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:{{name}}/main.dart';

void main() {
  testWithGame<MyGame>(
    'game will load and MyComponent responds to taps',
    MyGame.new,
    (game) async {
      await game.ready();

      expect(game.world.children.length, 1);
      expect(game.world.myComponent.speed, Vector2.zero());

      final dispatcher = game.firstChild<MultiTapDispatcher>()!;
      dispatcher.onTapDown(
        createTapDownEvents(
          game: game,
          localPosition: (game.size / 2).toOffset(),
          globalPosition: (game.size / 2).toOffset(),
        ),
      );

      expect(game.world.myComponent.speed, isNot(equals(Vector2.zero())));
    },
  );
}
