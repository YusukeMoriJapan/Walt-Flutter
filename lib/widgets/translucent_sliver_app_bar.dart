import 'dart:ui';

import 'package:flutter/material.dart';

class TranslucentSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        floating: true,
        pinned: true,
        delegate: _TranslucentSliverAppBarDelegate(
          MediaQuery.of(context).padding,
        )
    );
  }
}

class _TranslucentSliverAppBarDelegate extends SliverPersistentHeaderDelegate {

  /// This is required to calculate the height of the bar
  final EdgeInsets safeAreaPadding;

  _TranslucentSliverAppBarDelegate(this.safeAreaPadding);

  @override
  double get minExtent => safeAreaPadding.top;

  @override
  double get maxExtent => minExtent + kToolbarHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Opacity(
            opacity: 0.93,
            child: Container(
              // Don't wrap this in any SafeArea widgets, use padding instead
                padding: EdgeInsets.only(top: safeAreaPadding.top),
                height: maxExtent,
                color: Colors.white,
                // Use Stack and Positioned to create the toolbar slide up effect when scrolled up
                child: Stack(
                  overflow: Overflow.clip,
                  children: <Widget>[
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: AppBar(
                        primary: false,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        title: Text("Translucent App Bar"),
                      ),
                    )
                  ],
                )
            )
        )
    ));
  }

  @override
  bool shouldRebuild(_TranslucentSliverAppBarDelegate old) {
    return maxExtent != old.maxExtent || minExtent != old.minExtent ||
        safeAreaPadding != old.safeAreaPadding;
  }
}