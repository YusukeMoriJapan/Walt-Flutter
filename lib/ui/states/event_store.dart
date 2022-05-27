import 'package:hooks_riverpod/hooks_riverpod.dart';

final eventStoreProvider =
    Provider.autoDispose<EventStore>((ref) => EventStore());

class EventStore {
  bool isRefreshInvoked = false;
}
