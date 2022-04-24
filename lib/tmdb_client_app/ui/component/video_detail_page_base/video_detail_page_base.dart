import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/ui/component/video_detail_page_base/parts/video_detal_app_bar.dart';
import 'package:walt/tmdb_client_app/ui/component/video_detail_page_base/parts/sample_sliver_detail_list.dart';

class VideoDetailPageBase extends HookConsumerWidget {
  const VideoDetailPageBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarHeight = useState<double?>(null);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          VideoDetailAppBar(appBarHeight.value, (heightValue) {
            appBarHeight.value = heightValue;
          }),
          const SampleSliverDetailList(),
        ],
      ),
    );
  }
}
