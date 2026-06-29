import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ergomove/main.dart';

void main() {
  testWidgets('ErgoMove loads the bilingual timer UI', (tester) async {
    await tester.pumpWidget(const ErgoMoveApp());
    await tester.pumpAndSettle();

    expect(find.text('ErgoMove'), findsOneWidget);
    expect(find.text('شروع'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });
}
