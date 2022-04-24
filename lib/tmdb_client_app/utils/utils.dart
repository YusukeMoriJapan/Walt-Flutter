import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../constants/constants.dart';

String getTmdbApiKey() {
  final key = dotenv.get(tmdbApiKey);

  return key;
}
