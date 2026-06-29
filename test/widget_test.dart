import 'package:flutter_test/flutter_test.dart';
import 'package:ergomove/main.dart';

void main() {
  testWidgets('ErgoMove starts', (tester) async {
    await tester.pumpWidget(const ErgoMoveApp());
    expect(find.text('ErgoMove'), findsOneWidget);
  });
}
