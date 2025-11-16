// Weather App Widget Tests
//
// This file contains widget tests for the Weather App

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/main.dart';

void main() {
  testWidgets('Weather App smoke test', (WidgetTester tester) async {
    // Initialize SharedPreferences with mock values
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp(preferences: prefs));
    await tester.pump();

    // Verify that the app title is displayed
    expect(find.text('Weather App'), findsWidgets);
  });
}
