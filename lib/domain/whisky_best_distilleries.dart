import 'package:equatable/equatable.dart';

class WhiskyBestDistilleries with EquatableMixin {
  WhiskyBestDistilleries(this.name, this.slug, this.country, this.rating);

  final String name;
  final String slug;
  final String country;
  final String rating;

  @override
  List<Object?> get props => [name, slug, country, rating];
}
