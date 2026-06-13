import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:emergency_app/app_shell.dart';
import 'package:emergency_app/providers/app_preferences_provider.dart';

void main() {
  testWidgets('bottom navigation switches pages', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppPreferencesProvider(),
        child: const MaterialApp(home: AppShell()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
    expect(find.text('First Aid'), findsWidgets);
    expect(find.text('Contact'), findsWidgets);
    expect(find.text('Setting'), findsWidgets);

    await tester.tap(find.text('First Aid').last);
    await tester.pumpAndSettle();

    expect(find.text('Explore Guide'), findsOneWidget);

    await tester.tap(find.text('Contact').last);
    await tester.pumpAndSettle();

    expect(find.text('Emergency contacts'), findsOneWidget);

    await tester.tap(find.text('Setting').last);
    await tester.pumpAndSettle();

    expect(find.text('App Preferences'), findsOneWidget);
  });
}
