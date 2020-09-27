import 'package:FL_Foreman/providers/style_provider.dart';
import 'package:FL_Foreman/widget/state_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Consumer<StyleProvider>(
      builder: (context, style, child) {
        return ListView.builder(
          padding: EdgeInsets.only(top: style.listShowPaddingTop ? 16 : 0),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: itemBuilder,
          itemCount: itemCount,
        );
      },
    );
  }
}
