import 'package:walt/models/entity/movie/movie_detail/movie_details.dart';

import '../../../models/entity/people/credits.dart';

class MovieDetailsWithCredits {
  final MovieDetails movieDetails;
  final Credits? credits;

//<editor-fold desc="Data Methods">

  const MovieDetailsWithCredits({
    required this.movieDetails,
    this.credits,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is MovieDetailsWithCredits &&
              runtimeType == other.runtimeType &&
              movieDetails == other.movieDetails &&
              credits == other.credits);

  @override
  int get hashCode => movieDetails.hashCode ^ credits.hashCode;

  @override
  String toString() {
    return 'MovieDetailsWithCredits{ movieDetails: $movieDetails, credits: $credits,}';
  }

  MovieDetailsWithCredits copyWith({
    MovieDetails? movieDetails,
    Credits? credits,
  }) {
    return MovieDetailsWithCredits(
      movieDetails: movieDetails ?? this.movieDetails,
      credits: credits ?? this.credits,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'movieDetails': movieDetails,
      'credits': credits,
    };
  }

  factory MovieDetailsWithCredits.fromMap(Map<String, dynamic> map) {
    return MovieDetailsWithCredits(
      movieDetails: map['movieDetails'] as MovieDetails,
      credits: map['credits'] as Credits,
    );
  }

//</editor-fold>
}