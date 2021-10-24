import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(GameWidget(game: MyGame()));
    expect(find.byType(GameWidget), findsOneWidget);
  });
}
