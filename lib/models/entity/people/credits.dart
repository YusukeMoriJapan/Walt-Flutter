import 'package:walt/models/entity/people/cast.dart';
import 'package:walt/models/entity/people/crew.dart';

class Credits {
  int? id;
  List<Cast>? cast;
  List<Crew>? crew;

  Credits.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['cast'] != null) {
      cast = <Cast>[];
      json['cast'].forEach((v) {
        cast!.add(Cast.fromJson(v));
      });
    }
    if (json['crew'] != null) {
      crew = <Crew>[];
      json['crew'].forEach((v) {
        crew!.add(Crew.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (cast != null) {
      data['cast'] = cast!.map((v) => v.toJson()).toList();
    }
    if (crew != null) {
      data['crew'] = crew!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Credits({
    this.id,
    this.cast,
    this.crew,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Credits &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          cast == other.cast &&
          crew == other.crew);

  @override
  int get hashCode => id.hashCode ^ cast.hashCode ^ crew.hashCode;

  @override
  String toString() {
    return 'GetMovieCreditsResponse{' ' id: $id,' ' cast: $cast,' ' crew: $crew,' '}';
  }

  Credits copyWith({
    int? id,
    List<Cast>? cast,
    List<Crew>? crew,
  }) {
    return Credits(
      id: id ?? this.id,
      cast: cast ?? this.cast,
      crew: crew ?? this.crew,
    );
  }
}
