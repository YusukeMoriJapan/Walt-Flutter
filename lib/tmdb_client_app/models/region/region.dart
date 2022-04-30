enum Region { japan, us }

extension RegionEx on Region {
  String get name {
    switch (this) {
      case Region.japan:
        return 'JP';
      case Region.us:
        return 'US';
    }
  }
}