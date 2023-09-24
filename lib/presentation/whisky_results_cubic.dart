import 'package:example_app_1/domain/whisky_best_distilleries.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WhiskyResultsCubic extends Cubit<List<WhiskyBestDistilleries>> {
  WhiskyResultsCubic(super.initialState);

  // TODO: missing unit test
  void showResultsInDescOrder(List<WhiskyBestDistilleries> whiskyList) {
    whiskyList.sort((first, second) {
      final firstRating = double.parse(first.rating);
      final secondRating = double.parse(second.rating);
      if (firstRating == secondRating) {
        return 0;
      } else if (firstRating > secondRating) {
        return -1;
      } else {
        return 1;
      }
    });
    emit(whiskyList);
  }
}
