class SpokenLanguages {
  String? iso6391;
  String? name;

  SpokenLanguages({
    this.iso6391,
    this.name,
  });
  SpokenLanguages.fromJson(Map<String, dynamic> json) {
    iso6391 = json['iso_639_1'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['iso_639_1'] = iso6391;
    data['name'] = name;
    return data;
  }



  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is SpokenLanguages &&
              runtimeType == other.runtimeType &&
              iso6391 == other.iso6391 &&
              name == other.name);

  @override
  int get hashCode => iso6391.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'SpokenLanguages{' ' iso6391: $iso6391,' ' name: $name,' '}';
  }

  SpokenLanguages copyWith({
    String? iso6391,
    String? name,
  }) {
    return SpokenLanguages(
      iso6391: iso6391 ?? this.iso6391,
      name: name ?? this.name,
    );
  }
}