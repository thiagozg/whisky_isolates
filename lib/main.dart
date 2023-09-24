import 'package:example_app_1/data/whisky_remote_data_source.dart';
import 'package:example_app_1/domain/whisky_manager.dart';
import 'package:example_app_1/presentation/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  final whiskyRemoteDataSource = WhiskyRemoteDataSource(Client());
  final whiskyManager = WhiskyManager(whiskyRemoteDataSource);
  runApp(MyApp(whiskyManager: whiskyManager));
}
