import 'package:flutter/material.dart';

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar(this.color, this.tabBar, {Key? key}) : super(key: key);

  @override
  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
    color: color,
    child: tabBar,
  );
}