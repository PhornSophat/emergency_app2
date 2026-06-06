import 'package:flutter_test/flutter_test.dart';

import 'package:emergency_app/main.dart';

void main() {
  testWidgets('bottom navigation switches pages', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Home'), findsWidgets);
    expect(find.text('First Aid'), findsWidgets);
    expect(find.text('Contact'), findsWidgets);
    expect(find.text('Setting'), findsWidgets);

    await tester.tap(find.text('First Aid').last);
    await tester.pumpAndSettle();

    expect(find.text('First Aid'), findsWidgets);

    await tester.tap(find.text('Contact').last);
    await tester.pumpAndSettle();

    expect(find.text('Contact'), findsWidgets);

    await tester.tap(find.text('Setting').last);
    await tester.pumpAndSettle();

    expect(find.text('Setting'), findsWidgets);
  });
}
