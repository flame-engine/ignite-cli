import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:{{name}}/main.dart';

final myGame = FlameTester(MyGame.new);

void main() {
  myGame.testGameWidget(
    'game will load its child',
    verify: (game, tester) async {
      await tester.pumpWidget(GameWidget(game: game));

      expect(game.world.children.length, 1);
      expect(game.world.myComponent.speed, Vector2.zero());

      await tester.tapAt(const Offset(10, 10));
      await tester.pump(const Duration(milliseconds: 100));

      expect(game.world.myComponent.speed, isNot(equals(Vector2.zero())));
    },
  );
}
