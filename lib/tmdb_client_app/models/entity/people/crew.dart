class Crew {
  bool? adult;
  int? gender;
  int? id;
  String? knownForDepartment;
  String? name;
  String? originalName;
  double? popularity;
  String? profilePath;
  String? creditId;
  String? department;
  String? job;

  Crew.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    gender = json['gender'];
    id = json['id'];
    knownForDepartment = json['known_for_department'];
    name = json['name'];
    originalName = json['original_name'];
    popularity = json['popularity'];
    profilePath = json['profile_path'];
    creditId = json['credit_id'];
    department = json['department'];
    job = json['job'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adult'] = adult;
    data['gender'] = gender;
    data['id'] = id;
    data['known_for_department'] = knownForDepartment;
    data['name'] = name;
    data['original_name'] = originalName;
    data['popularity'] = popularity;
    data['profile_path'] = profilePath;
    data['credit_id'] = creditId;
    data['department'] = department;
    data['job'] = job;
    return data;
  }

//<editor-fold desc="Data Methods">

  Crew({
    this.adult,
    this.gender,
    this.id,
    this.knownForDepartment,
    this.name,
    this.originalName,
    this.popularity,
    this.profilePath,
    this.creditId,
    this.department,
    this.job,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Crew &&
          runtimeType == other.runtimeType &&
          adult == other.adult &&
          gender == other.gender &&
          id == other.id &&
          knownForDepartment == other.knownForDepartment &&
          name == other.name &&
          originalName == other.originalName &&
          popularity == other.popularity &&
          profilePath == other.profilePath &&
          creditId == other.creditId &&
          department == other.department &&
          job == other.job);

  @override
  int get hashCode =>
      adult.hashCode ^
      gender.hashCode ^
      id.hashCode ^
      knownForDepartment.hashCode ^
      name.hashCode ^
      originalName.hashCode ^
      popularity.hashCode ^
      profilePath.hashCode ^
      creditId.hashCode ^
      department.hashCode ^
      job.hashCode;

  @override
  String toString() {
    return 'Crew{' +
        ' adult: $adult,' +
        ' gender: $gender,' +
        ' id: $id,' +
        ' knownForDepartment: $knownForDepartment,' +
        ' name: $name,' +
        ' originalName: $originalName,' +
        ' popularity: $popularity,' +
        ' profilePath: $profilePath,' +
        ' creditId: $creditId,' +
        ' department: $department,' +
        ' job: $job,' +
        '}';
  }

  Crew copyWith({
    bool? adult,
    int? gender,
    int? id,
    String? knownForDepartment,
    String? name,
    String? originalName,
    double? popularity,
    String? profilePath,
    String? creditId,
    String? department,
    String? job,
  }) {
    return Crew(
      adult: adult ?? this.adult,
      gender: gender ?? this.gender,
      id: id ?? this.id,
      knownForDepartment: knownForDepartment ?? this.knownForDepartment,
      name: name ?? this.name,
      originalName: originalName ?? this.originalName,
      popularity: popularity ?? this.popularity,
      profilePath: profilePath ?? this.profilePath,
      creditId: creditId ?? this.creditId,
      department: department ?? this.department,
      job: job ?? this.job,
    );
  }
}