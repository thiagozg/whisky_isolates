import 'package:example_app_1/data/http_state.dart';
import 'package:example_app_1/data/whisky_remote_data_source.dart';
import 'package:example_app_1/data/whisky_response.dart';
import 'package:example_app_1/domain/whisky_best_distilleries.dart';
import 'package:example_app_1/domain/whisky_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWhiskyRemoteDataSource extends Mock
    implements WhiskyRemoteDataSource {}

void main() {
  final mockWhiskyRemoteDataSource = MockWhiskyRemoteDataSource();
  final whiskyManager = WhiskyManager(
    mockWhiskyRemoteDataSource,
    fetchHttpFn: (applyFn) => applyFn(),
  );

  group('when success data', () {
    final nonEmptyResponse = Future.value(HttpState.success([
      const WhiskyResponse(
          name: '1',
          slug: '1',
          country: '1',
          totalWhiskies: '10',
          totalVotes: '10',
          rating: '10'),
      const WhiskyResponse(
          name: '2',
          slug: '2',
          country: '2',
          totalWhiskies: '20',
          totalVotes: '20',
          rating: '20'),
    ]));
    when(() => mockWhiskyRemoteDataSource.fetchAll())
        .thenAnswer((_) => nonEmptyResponse);

    test(
      'given an non empty list and no filter'
      'should return the same list',
      () async {
        final actual = await whiskyManager.getBestDistilleries(0, 0);
        final expected = [
          WhiskyBestDistilleries('1', '1', '1', '10'),
          WhiskyBestDistilleries('2', '2', '2', '20'),
        ];
        expect(actual, equals(expected));
      },
    );
    test(
      'given an non empty list and filters'
      'should return the list filtered',
      () async {
        final actual = await whiskyManager.getBestDistilleries(0, 20);
        final expected = [
          WhiskyBestDistilleries('2', '2', '2', '20'),
        ];
        expect(actual, equals(expected));
      },
    );
  });

  test(
    'when no success data'
    'should return an empty list',
    () async {
      final errorResponse = Future.value(HttpState.error(Exception()));
      when(() => mockWhiskyRemoteDataSource.fetchAll())
          .thenAnswer((_) => errorResponse);
      final actual = await whiskyManager.getBestDistilleries(0, 20);
      expect(actual, equals([]));
    },
  );
}
