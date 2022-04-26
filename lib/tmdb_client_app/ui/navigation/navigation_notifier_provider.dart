import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/tmdb_client_app/ui/navigation/page_model.dart';

import 'navigation_notifier.dart';

final navigationProvider = StateNotifierProvider<NavigationNotifier, PageModel>(
        (ref) => NavigationNotifier());