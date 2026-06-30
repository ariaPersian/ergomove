import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ergomove/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('ErgoMove loads the timer shell', (tester) async {
    await tester.pumpWidget(const ErgoMoveApp());
    await tester.pumpAndSettle();

    expect(find.text('ErgoMove'), findsOneWidget);
  });
}
