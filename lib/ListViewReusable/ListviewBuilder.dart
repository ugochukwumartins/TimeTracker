import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracking_app/Homes/Empty.dart';

typedef ItemWodgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemBuilder<T> extends StatelessWidget {
  const ListItemBuilder(
      {Key key, @required this.snapshot, @required this.itembuider})
      : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWodgetBuilder<T> itembuider;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        // return something
        return _buildList(items);
      } else {
        return EmptyPage();
      }
    } else if (snapshot.hasError) {
      return EmptyPage(
        title: "Somrthing went Wrong",
        message: 'cant\t load item right now',
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
        itemCount: items.length + 2,
        separatorBuilder: (context, index) => Divider(
              height: 0.5,
            ),
        itemBuilder: (context, index) {
          if (index == 0 || index == items.length + 1) {
            return Container();
          }
          return itembuider(
            context,
            items[index - 1],
          );
        });
  }
}
