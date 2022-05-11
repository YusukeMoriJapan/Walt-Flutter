class ProductionCompanies {
  int? id;
  String? logoPath;
  String? name;
  String? originCountry;

  ProductionCompanies({
    this.id,
    this.logoPath,
    this.name,
    this.originCountry,
  });

  ProductionCompanies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logoPath = json['logo_path'];
    name = json['name'];
    originCountry = json['origin_country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['logo_path'] = logoPath;
    data['name'] = name;
    data['origin_country'] = originCountry;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is ProductionCompanies &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              logoPath == other.logoPath &&
              name == other.name &&
              originCountry == other.originCountry);

  @override
  int get hashCode =>
      id.hashCode ^ logoPath.hashCode ^ name.hashCode ^ originCountry.hashCode;

  @override
  String toString() {
    return 'ProductionCompanies{' ' id: $id,' ' logoPath: $logoPath,' ' name: $name,' ' originCountry: $originCountry,' +
        '}';
  }

  ProductionCompanies copyWith({
    int? id,
    String? logoPath,
    String? name,
    String? originCountry,
  }) {
    return ProductionCompanies(
      id: id ?? this.id,
      logoPath: logoPath ?? this.logoPath,
      name: name ?? this.name,
      originCountry: originCountry ?? this.originCountry,
    );
  }
}