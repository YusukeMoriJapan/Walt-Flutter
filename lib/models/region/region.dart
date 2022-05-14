import '../../utils/log/logger.dart';

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

Region ianaCodeToRegion(String? countryCode) {
  switch (countryCode) {
    case 'US':
      return Region.us;
    case 'JP':
      return Region.japan;
  }
  logger.d("countryCode is $countryCode :Since no matching language code found, applied US instead.");
  return Region.us;
}
