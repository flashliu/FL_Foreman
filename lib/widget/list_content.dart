import 'package:FL_Foreman/widget/state_layout.dart';
import 'package:flutter/material.dart';

class ListContent extends StatelessWidget {
  final String emptyText;
  final Function(BuildContext, int) itemBuilder;
  final int itemCount;

  const ListContent({
    Key key,
    @required this.itemBuilder,
    @required this.emptyText,
    @required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) {
      return StateLayout(
        type: StateType.empty,
        hintText: emptyText,
      );
    }
    return ListView.builder(
      padding: EdgeInsets.only(top: 0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: itemBuilder,
      itemCount: itemCount,
    );
  }
}
