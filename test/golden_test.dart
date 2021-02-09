import 'package:flutter_test/flutter_test.dart';

import '../example/flutter_layout_grid.dart';

void main() {
  testWidgets('Piet screenshot test', (tester) async {
    await tester.pumpWidget(PietApp());
    await expectLater(
      find.byType(PietApp),
      matchesGoldenFile('goldens/piet.png'),
    );
  });
}
