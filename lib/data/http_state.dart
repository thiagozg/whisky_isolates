import 'package:equatable/equatable.dart';
import 'package:example_app_1/data/whisky_response.dart';

class HttpState with EquatableMixin {
  HttpState._(this.whiskyResponseList, this.error);

  HttpState.success(this.whiskyResponseList) : error = null;

  HttpState.error(this.error) : whiskyResponseList = null;

  final List<WhiskyResponse>? whiskyResponseList;
  final Object? error;

  bool get hasSuccessData => whiskyResponseList != null;

  @override
  List<Object?> get props => [whiskyResponseList, error];
}
