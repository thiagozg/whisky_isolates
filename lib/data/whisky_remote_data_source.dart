import 'dart:convert';

import 'package:example_app_1/data/http_state.dart';
import 'package:example_app_1/data/whisky_response.dart';
import 'package:http/http.dart';

class WhiskyRemoteDataSource {
  WhiskyRemoteDataSource(this._httpClient);

  final Client _httpClient;

  Future<HttpState> fetchAll() async {
    try {
      final uri = Uri.https(
        'whiskyhunter.net',
        '/api/distilleries_info',
        {'format': 'json'},
      );
      final response = await _httpClient.get(uri);
      if (response.statusCode >= 200 && response.statusCode < 400) {
        if (response.bodyBytes.isNotEmpty &&
            response.headers['content-type'] == 'application/json') {
          final jsonList = jsonDecode(utf8.decode(response.bodyBytes)) as List;
          final whiskyResponseList = jsonList
              .map((e) => WhiskyResponse.fromJson(e))
              .toList();
          return HttpState.success(whiskyResponseList);
        }
      }

      return HttpState.success(<WhiskyResponse>[]);
    } catch (e) {
      return HttpState.error(e);
    }
  }
}
