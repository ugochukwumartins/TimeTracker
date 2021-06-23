import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracking_app/Homes/tab_item.dart';

import 'Home_Page.dart';
import 'job_entries/job_entries_page.dart';

class CupatinoHomeScaffold extends StatelessWidget {
  const CupatinoHomeScaffold({
    Key key,
    @required this.current,
    @required this.onSelected,
    @required this.widgetbuilder,
    @required this.navigatorKey,
  }) : super(key: key);
  final Tabitem current;
  final ValueChanged<Tabitem> onSelected;
  final Map<Tabitem, WidgetBuilder> widgetbuilder;
  final Map<Tabitem, GlobalKey<NavigatorState>> navigatorKey;
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _buildItem(Tabitem.Job),
          _buildItem(Tabitem.Entry),
          _buildItem(Tabitem.Account),
        ],
        onTap: (index) => onSelected(Tabitem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item = Tabitem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKey[item],
          builder: (context) => widgetbuilder[item](context),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(Tabitem tabitem) {
    final itemdata = TabItemData.alltabs[tabitem];
    final colors = current == tabitem ? Colors.indigo : Colors.grey;
    return BottomNavigationBarItem(
      icon: Icon(
        itemdata.icon,
        color: colors,
      ),
      title: Text(
        itemdata.title,
        style: TextStyle(
          color: colors,
        ),
      ),
    );
  }
}
