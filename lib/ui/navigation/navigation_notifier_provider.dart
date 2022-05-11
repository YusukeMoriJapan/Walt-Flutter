import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walt/ui/navigation/page_model.dart';

import 'navigation_notifier.dart';

final navigationProvider = StateNotifierProvider<NavigationNotifier, PageModel>(
        (ref) => NavigationNotifier());