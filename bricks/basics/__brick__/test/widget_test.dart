import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:{{name}}/main.dart';

final myGame = FlameTester(MyGame.new);

void main() {
  myGame.testGameWidget(
    'game will load its child',
    verify: (game, tester) async {
      game.update(0.0);

      expect(game.children.length, 1);
      expect(game.myComponent.speed, Vector2.zero());

      await tester.tapAt(const Offset(10, 10));
      expect(game.myComponent.speed, isNot(equals(Vector2.zero())));
    },
  );
}
