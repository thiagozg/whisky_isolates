import 'package:example_app_1/domain/whisky_best_distilleries.dart';
import 'package:example_app_1/domain/whisky_manager.dart';
import 'package:example_app_1/presentation/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWhiskyManager extends Mock implements WhiskyManager {}

void main() {
  final mockWhiskyManager = MockWhiskyManager();

  testWidgets('given an empty result should show a form', (widgetTester) async {
    when(() => mockWhiskyManager.getBestDistilleries(any(), any()))
        .thenAnswer((_) => Future.value([]));
    await widgetTester.pumpWidget(MyApp(whiskyManager: mockWhiskyManager));

    await widgetTester.enterText(
        find.byKey(const ValueKey('votes-field')), '1');
    await widgetTester.enterText(
        find.byKey(const ValueKey('rating-field')), '1');
    await widgetTester.tap(find.byIcon(Icons.search));
    await widgetTester.pumpAndSettle();

    expect(find.text('Enter the desired filters'), findsOneWidget);
  });

  testWidgets('given an non empty result should show the first result',
      (widgetTester) async {
    when(() => mockWhiskyManager.getBestDistilleries(any(), any()))
        .thenAnswer((_) => Future.value([WhiskyBestDistilleries('name', '', '', '5.0')]));
    await widgetTester.pumpWidget(MyApp(whiskyManager: mockWhiskyManager));

    await widgetTester.enterText(
        find.byKey(const ValueKey('votes-field')), '1');
    await widgetTester.enterText(
        find.byKey(const ValueKey('rating-field')), '1');
    await widgetTester.tap(find.byIcon(Icons.search));
    await widgetTester.pumpAndSettle();

    expect(find.textContaining('name'), findsOneWidget);
    expect(find.textContaining('5.0'), findsOneWidget);
  });
}
