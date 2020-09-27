import 'package:FL_Foreman/models/foreman_model.dart';
import 'package:flutter/material.dart';

class ForemanDetail extends StatefulWidget {
  final Foreman info;
  ForemanDetail({Key key, @required this.info}) : super(key: key);

  @override
  _ForemanDetailState createState() => _ForemanDetailState();
}

class _ForemanDetailState extends State<ForemanDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.chevron_left),
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text('工头详情'),
        titleSpacing: 0,
      ),
    );
  }
}
