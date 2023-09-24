import 'package:equatable/equatable.dart';

/// name : "8 Doors Distillery"
/// slug : "8_doors"
/// country : "Scotland"
/// whiskybase_whiskies : "4"
/// whiskybase_votes : "5"
/// whiskybase_rating : "86.5"

class WhiskyResponse with EquatableMixin {
  const WhiskyResponse({
    required this.name,
    required this.slug,
    required this.country,
    required this.totalWhiskies,
    required this.totalVotes,
    required this.rating,
  });

  factory WhiskyResponse.fromJson(Map<String, dynamic> json) {
    return WhiskyResponse(
      name: json['name'],
      slug: json['slug'],
      country: json['country'],
      totalWhiskies: json['whiskybase_whiskies'],
      totalVotes: json['whiskybase_votes'],
      rating: json['whiskybase_rating'],
    );
  }

  final String name;
  final String slug;
  final String country;
  final String totalWhiskies;
  final String totalVotes;
  final String rating;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['name'] = name;
    json['slug'] = slug;
    json['country'] = country;
    json['whiskybase_whiskies'] = totalWhiskies;
    json['whiskybase_votes'] = totalVotes;
    json['whiskybase_rating'] = rating;
    return json;
  }

  @override
  List<Object?> get props => [
        name,
        slug,
        country,
        totalWhiskies,
        totalVotes,
        rating,
      ];
}
