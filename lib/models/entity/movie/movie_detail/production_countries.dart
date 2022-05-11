class ProductionCountries {
  String? iso31661;
  String? name;

  ProductionCountries({
    this.iso31661,
    this.name,
  });

  ProductionCountries.fromJson(Map<String, dynamic> json) {
    iso31661 = json['iso_3166_1'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['iso_3166_1'] = iso31661;
    data['name'] = name;
    return data;
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is ProductionCountries &&
              runtimeType == other.runtimeType &&
              iso31661 == other.iso31661 &&
              name == other.name);

  @override
  int get hashCode => iso31661.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'ProductionCountries{' ' iso31661: $iso31661,' ' name: $name,' '}';
  }

  ProductionCountries copyWith({
    String? iso31661,
    String? name,
  }) {
    return ProductionCountries(
      iso31661: iso31661 ?? this.iso31661,
      name: name ?? this.name,
    );
  }
}