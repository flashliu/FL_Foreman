import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// design/9暂无状态页面/index.html#artboard3
class StateLayout extends StatefulWidget {
  const StateLayout({Key key, @required this.type, this.hintText, this.bgColor}) : super(key: key);

  final StateType type;
  final String hintText;
  final Color bgColor;

  @override
  _StateLayoutState createState() => _StateLayoutState();
}

class _StateLayoutState extends State<StateLayout> {
  Widget _img;
  String _hintText;

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case StateType.loading:
        _img = Icon(
          Icons.refresh,
          color: ColorCenter.green,
        );
        break;
      case StateType.empty:
        _img = Svgs.emptyHolder;
        break;
      case StateType.network:
        _img = Icon(
          Icons.signal_wifi_off,
          color: ColorCenter.green,
        );
        break;
    }
    return Container(
      color: widget.bgColor ?? ColorCenter.whiteSmoke,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _img,
          SizedBox(
            height: 20,
          ),
          Text(
            widget.hintText ?? _hintText,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

enum StateType {
  /// 无网络
  network,

  /// 加载中
  loading,

  /// 空
  empty
}
