import 'package:flutter/material.dart';
import 'package:time_tracking_app/Homes/tab_item.dart';
import 'package:time_tracking_app/Models/entry.dart';

import 'Account.dart';
import 'CupatinoHomeScalfold.dart';
import 'Home_Page.dart';
import 'entries/entries_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Tabitem _currentTab = Tabitem.Job;
  Map<Tabitem, GlobalKey<NavigatorState>> navigatorKey = {
    Tabitem.Job: GlobalKey<NavigatorState>(),
    Tabitem.Entry: GlobalKey<NavigatorState>(),
    Tabitem.Account: GlobalKey<NavigatorState>(),
  };
  Map<Tabitem, WidgetBuilder> get widgetbuilder {
    return {
      Tabitem.Job: (_) => JobsPage(),
      Tabitem.Entry: (context) => EntriesPage.create(context),
      Tabitem.Account: (_) => AccounPage(),
    };
  }

  void _select(Tabitem tabitem) {
    if (tabitem == _currentTab) {
      navigatorKey[tabitem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = tabitem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => navigatorKey[_currentTab].currentState.maybePop(),
      child: CupatinoHomeScaffold(
        current: _currentTab,
        onSelected: _select,
        widgetbuilder: widgetbuilder,
        navigatorKey: navigatorKey,
      ),
    );
  }
}
