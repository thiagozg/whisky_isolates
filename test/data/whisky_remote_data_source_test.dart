import 'dart:convert';
import 'dart:io';

import 'package:example_app_1/data/http_state.dart';
import 'package:example_app_1/data/whisky_remote_data_source.dart';
import 'package:example_app_1/data/whisky_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements Client {}

void main() {
  final mockHttpClient = MockHttpClient();
  final whiskyRemoteDataSource = WhiskyRemoteDataSource(mockHttpClient);

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('given a success response should respond a HttpState.success', () {
    test('when JSON Content Type header with parse data', () async {
      const body =
          '[{"name": "name", "slug": "slug", "country": "country", "whiskybase_whiskies": "whiskybase_whiskies", "whiskybase_votes": "whiskybase_votes", "whiskybase_rating": "whiskybase_rating"}]';
      final response =
          Response(body, 200, headers: {'content-type': 'application/json'});
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

      final actual = await whiskyRemoteDataSource.fetchAll();
      final expected = HttpState.success(
          [WhiskyResponse.fromJson((jsonDecode(body) as List).first)]);
      expect(actual, equals(expected));
    });

    test('when no JSON Content Type header without parsed data', () async {
      const body = [1, 2, 3];
      final response = Response.bytes(body, 200,
          headers: {'content-type': 'application/octet-stream'});
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

      final actual = await whiskyRemoteDataSource.fetchAll();
      final expected = HttpState.success([]);
      expect(actual, equals(expected));
    });

    test('when empty data should with empty list', () async {
      const body = '{}';
      final response = Response(body, 200,
          headers: {'content-type': 'application/application-json'});
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

      final actual = await whiskyRemoteDataSource.fetchAll();
      final expected = HttpState.success([]);
      expect(actual, equals(expected));
    });
  });

  test(
    'given an error response '
    'should respond a HttpState.error with actual exception',
    () async {
      final testException = Exception('text exception');
      when(() => mockHttpClient.get(any())).thenThrow(testException);

      final actual = await whiskyRemoteDataSource.fetchAll();
      expect(actual, HttpState.error(testException));
    },
  );

  test(
    'given an invalid data response '
    'should respond a HttpState.error with actual exception',
    () async {
      const body = [1, 2, 3];
      final response = Response.bytes(body, 200,
          headers: {'content-type': 'application/json'});
      when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

      final actual = await whiskyRemoteDataSource.fetchAll();
      expect(
          actual,
          predicate((HttpState value) =>
              value.error!.runtimeType == FormatException));
    },
  );
}
