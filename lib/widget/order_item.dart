import 'dart:async';

import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/common/order_action.dart';
import 'package:FL_Foreman/models/countdown_model.dart';
import 'package:FL_Foreman/models/order_model.dart';
import 'package:FL_Foreman/providers/order_provider.dart';
import 'package:FL_Foreman/providers/style_provider.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/views/home/create_order.dart';
import 'package:FL_Foreman/views/nurse_detail/nurse_detail.dart';
import 'package:FL_Foreman/views/order_detail/order_detail.dart';
import 'package:FL_Foreman/views/refund/refund.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

String orderStatus(String status) {
  final statusMap = {
    '1': '待付款',
    '2': '已付款',
    '3': '待结算',
    '4': '待评价',
    '5': '已评价',
    '6': '已取消',
    '7': '已过期',
    '12': '已派单待执行',
    '20': '待执行',
    '21': '执行中',
    '99': '抢单中'
  };

  return statusMap[status];
}

class OrderItem extends StatefulWidget {
  final Order info;
  const OrderItem({Key key, this.info}) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  CountDown countDown = CountDown(day: '00', hour: '00', min: '00', sec: '00');
  Timer timer;

  @override
  void initState() {
    super.initState();
    setCountDown();
  }

  setCountDown() {
    final startTime = DateTime.parse(widget.info.startTime);
    if (startTime.isAfter(DateTime.now())) {
      setState(() {
        countDown = CountDown.fromTime(startTime);
      });
      timer = Timer.periodic(Duration(seconds: 1), (_) {
        final newCountDown = CountDown.fromTime(startTime);
        if (int.parse(newCountDown.day) < 0) {
          return timer.cancel();
        }
        setState(() {
          countDown = newCountDown;
        });
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  List<Widget> buildNurseItem() {
    return widget.info.nurseList.map((item) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          children: [
            Positioned.fill(
              child: InkWell(
                onTap: () {
                  return Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => NurseDetail(
                        info: item,
                      ),
                    ),
                  );
                },
                child: Builder(builder: (_) {
                  if (item.headImg == null || item.headImg.isEmpty) {
                    return Image.asset(
                      'assets/images/nurse_avatar.png',
                      fit: BoxFit.cover,
                    );
                  }
                  return Image.network(
                    item.headImg,
                    fit: BoxFit.cover,
                  );
                }),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 18,
                width: double.infinity,
                alignment: Alignment.center,
                color: Color.fromRGBO(0, 0, 0, 0.4),
                child: Text(
                  item.realName,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            )
          ],
        ),
      );
    }).toList();
  }

  buildNurseList() {
    if (widget.info.nurseList.length == 0) return Container();
    return SizedBox(
      height: 67,
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 18,
          childAspectRatio: 67 / 48,
        ),
        scrollDirection: Axis.horizontal,
        children: [
          ...buildNurseItem(),
          InkWell(
            onTap: () => Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (_) => ChangeNotifierProvider<OrderProvider>(
                  create: (_) => OrderProvider(widget.info),
                  child: OrderDetail(index: 1),
                ),
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Color(0xFFF5F7F8),
                border: Border.all(color: Color(0xFFDDDDDD)),
              ),
              child: Text(
                '查看更多',
                style: TextStyle(color: Color(0xFF00A2E6), fontSize: 10),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Visibility(
          visible: true,
          child: OutlineButton(
            onPressed: () => OrderAction.renew(context: context, info: widget.info),
            child: Text('续费', style: TextStyles.black_14),
            borderSide: BorderSide(width: 1, color: Colors.grey),
            highlightedBorderColor: Colors.grey,
            color: Colors.white,
            textColor: ColorCenter.textBlack,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        Visibility(
          visible: widget.info.isRefund != 2 && widget.info.userId == Global.userId,
          child: OutlineButton(
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (_) => ChangeNotifierProvider<OrderProvider>(
                    create: (_) => OrderProvider(widget.info),
                    child: Refund(),
                  ),
                ),
              );
            },
            child: Text(widget.info.isRefund == 1 ? '查看退款' : '退款', style: TextStyles.black_14),
            borderSide: BorderSide(width: 1, color: Colors.grey),
            highlightedBorderColor: Colors.grey,
            color: Colors.white,
            textColor: ColorCenter.textBlack,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        SizedBox(width: 8),
        Visibility(
          visible: widget.info.isSettlement == 1,
          child: FlatButton(
            onPressed: () => OrderAction.settlement(
              context: context,
              orderId: widget.info.orderId,
            ),
            child: Text('立即结算', style: TextStyle(fontSize: 12)),
            color: ColorCenter.themeColor,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        SizedBox(width: 8),
        Visibility(
          visible: widget.info.userId == Global.userId,
          child: FlatButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (_) => CreateOrder()));
            },
            child: Text('再下一单', style: TextStyle(fontSize: 14)),
            color: ColorCenter.themeColor,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final nomalText = TextStyle(fontSize: 12, color: ColorCenter.textGrey);
    return Pannel(
      onTap: () => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<OrderProvider>(
            create: (_) => OrderProvider(widget.info),
            child: OrderDetail(
              showNurse: Provider.of<StyleProvider>(context).showNurse,
            ),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.info.demandName, style: TextStyles.title),
              Text(orderStatus(widget.info.status.toString()),
                  style: TextStyle(color: Color(0xFF00A2E6), fontSize: 12)),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 15,
                color: Colors.grey,
              ),
              SizedBox(width: 4),
              Text(
                '${widget.info.startTime} 至 ${widget.info.endTime}',
                style: TextStyle(fontSize: 14, color: ColorCenter.textBlack),
              ),
              Expanded(
                child: Text(
                  widget.info?.serverTime,
                  style: nomalText,
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xFFF5F7F8),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: EdgeInsets.only(left: 20, bottom: 10, top: 10, right: 10),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/img_location.png',
                  width: 16,
                  height: 16,
                ),
                SizedBox(width: 8),
                Text(
                  widget.info.beNursed.realName,
                  style: TextStyles.black_Bold_14.copyWith(fontSize: 12),
                )
              ],
            ),
          ),
          Row(
            children: [
              Text(
                '结束倒计时：${countDown.day}天 ${countDown.hour}:${countDown.min}:${countDown.sec}',
                style: nomalText,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '¥',
                      style: TextStyles.price.copyWith(fontSize: 12, height: 1.7),
                    ),
                    Text(
                      widget.info.amount.toString(),
                      style: TextStyles.price.copyWith(fontSize: 18),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('预约编号：${widget.info.id}', style: nomalText),
          SizedBox(height: 8),
          buildNurseList(),
          buildActions(),
        ],
      ),
    );
  }
}

class OrderItemShimmer extends StatelessWidget {
  const OrderItemShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Pannel(
      onTap: () {},
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200],
        highlightColor: Colors.grey[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(color: Colors.grey[800], width: 70, height: 15),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(color: Colors.grey[800], width: 150, height: 15),
                Container(color: Colors.grey[800], width: 70, height: 15),
              ],
            ),
            Container(
              height: 40,
              margin: EdgeInsets.symmetric(vertical: 16),
              color: Colors.grey[800],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(color: Colors.grey[800], width: 150, height: 15),
                Container(color: Colors.grey[800], width: 80, height: 20),
              ],
            ),
            SizedBox(height: 14),
            Container(color: Colors.grey[800], width: 150, height: 15),
            SizedBox(height: 8),
            Container(color: Colors.grey[800], height: 67),
          ],
        ),
      ),
    );
  }
}
