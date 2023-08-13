
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
 

  final Widget? leading;
  final List<Widget>? action;
  @override
  final Size preferredSize;
  TopBar(
      {required this.title,
     
      this.leading, this.action})
      : preferredSize = Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return (Platform.isIOS
          ? const CupertinoNavigationBar()
          :  AppBar(
      title: title,
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading:leading,
      actions:action,
    ))  as PreferredSizeWidget;
  }
}