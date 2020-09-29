import 'package:FL_Foreman/views/home/nurse_page.dart';
import 'package:flutter/material.dart';

class ForemanNurseList extends StatefulWidget {
  final String parentId;
  ForemanNurseList({Key key, this.parentId}) : super(key: key);

  @override
  _ForemanNurseListState createState() => _ForemanNurseListState();
}

class _ForemanNurseListState extends State<ForemanNurseList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.chevron_left),
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text('我的护工'),
        titleSpacing: 0,
      ),
      body: NursePage(
        parentId: widget.parentId,
        showAction: false,
      ),
    );
  }
}
