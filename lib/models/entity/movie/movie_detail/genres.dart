class Genres {
  int? id;
  String? name;

  Genres({
    this.id,
    this.name,
  });

  Genres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Genres &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name);

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'Genres{' ' id: $id,' ' name: $name,' '}';
  }

  Genres copyWith({
    int? id,
    String? name,
  }) {
    return Genres(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}