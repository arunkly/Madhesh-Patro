import 'package:flutter_test/flutter_test.dart';
import 'package:madhesh_patro/main.dart';

void main() {
  testWidgets('Madhesh Patro launches with home dashboard', (tester) async {
    await tester.pumpWidget(const MadheshPatroApp());
    expect(find.text('MADHESH PATRO'), findsOneWidget);
    expect(find.text('आजको दिन'), findsOneWidget);
  });

  testWidgets('Calendar tab opens', (tester) async {
    await tester.pumpWidget(const MadheshPatroApp());
    await tester.tap(find.text('पात्रो').last);
    await tester.pumpAndSettle();
    expect(find.text('नेपाली पात्रो'), findsOneWidget);
  });
}
