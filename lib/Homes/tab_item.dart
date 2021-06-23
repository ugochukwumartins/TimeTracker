import 'package:flutter/material.dart';

enum Tabitem {
  Job,
  Entry,
  Account,
}

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});
  final String title;
  final IconData icon;
  static const Map<Tabitem, TabItemData> alltabs = {
    Tabitem.Job: TabItemData(title: "Jobs", icon: Icons.work),
    Tabitem.Entry: TabItemData(title: "Entry", icon: Icons.view_headline),
    Tabitem.Account: TabItemData(title: "Account", icon: Icons.person),
  };
}
