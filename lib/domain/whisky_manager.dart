import 'dart:isolate';

import 'package:example_app_1/data/http_state.dart';
import 'package:example_app_1/data/whisky_remote_data_source.dart';
import 'package:example_app_1/domain/whisky_best_distilleries.dart';

typedef FetchHttpFn = Future<HttpState> Function(
    Future<HttpState> Function() apply);

// some people like to call this as UseCase (e.g.: GetBestDistilleriesUseCase)
class WhiskyManager {
  WhiskyManager(
    this._whiskyRemoteDataSource, {
    FetchHttpFn? fetchHttpFn,
  }) : _fetchHttpFn = fetchHttpFn ?? _fetchHttpFnDefault;

  final WhiskyRemoteDataSource _whiskyRemoteDataSource;
  final FetchHttpFn _fetchHttpFn;

  static Future<HttpState> _fetchHttpFnDefault(
          Future<HttpState> Function() applyFn) => Isolate.run(applyFn);

  Future<List<WhiskyBestDistilleries>> getBestDistilleries(
    int votesMinimum,
    double ratingMinimum,
  ) async {
    final httpState =
        await _fetchHttpFn(() => _whiskyRemoteDataSource.fetchAll());
    if (httpState.hasSuccessData) {
      // playing around with Ports
      final receivePort = ReceivePort();
      final isolate = await Isolate.spawn<Map<String, dynamic>>(
        _filterResponse,
        {
          'sendPort': receivePort.sendPort,
          'httpState': httpState,
          'votesMinimum': votesMinimum,
          'ratingMinimum': ratingMinimum
        },
      );
      final whiskyBestDistilleries = await receivePort.first as List<dynamic>;
      isolate.kill(priority: Isolate.immediate);
      return whiskyBestDistilleries.cast<WhiskyBestDistilleries>();
    }

    return <WhiskyBestDistilleries>[];
  }

  static void _filterResponse(Map<String, dynamic> message) {
    final sendPort = message['sendPort'];
    final httpState = message['httpState'];
    final whiskyBestDistilleries = httpState.whiskyResponseList!.where((info) {
      int totalVotes = int.parse(info.totalVotes);
      double rating = double.parse(info.rating);
      final votesMinimum = message['votesMinimum'];
      final ratingMinimum = message['ratingMinimum'];
      return totalVotes >= votesMinimum && rating >= ratingMinimum;
    }).map((e) => WhiskyBestDistilleries(e.name, e.slug, e.country, e.rating));
    sendPort.send(whiskyBestDistilleries.toList());
  }
}
