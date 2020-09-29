import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/common/order_action.dart';
import 'package:FL_Foreman/providers/order_provider.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/views/home/create_order.dart';
import 'package:FL_Foreman/views/refund/refund.dart';
import 'package:FL_Foreman/widget/label_value.dart';
import 'package:FL_Foreman/widget/nurse_item.dart';
import 'package:FL_Foreman/widget/order_item.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetail extends StatefulWidget {
  final int index;
  final bool showNurse;
  OrderDetail({
    Key key,
    this.index = 0,
    this.showNurse = true,
  }) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> with SingleTickerProviderStateMixin {
  TabController tabController;
  double bottom;

  @override
  void initState() {
    super.initState();
    bottom = widget.index == 0 ? 0 : -70;
    tabController = TabController(length: widget.showNurse ? 2 : 1, vsync: this, initialIndex: widget.index)
      ..addListener(() {
        setState(() {
          if (tabController.index == 1) {
            bottom = -70;
          } else {
            bottom = 0;
          }
        });
      });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final info = Provider.of<OrderProvider>(context).info;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 164,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.75, 1],
                colors: [Color(0xFF0C9AE0), Color.fromRGBO(66, 193, 247, 0)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                    children: [
                      InkWell(
                        child: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                        ),
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 60, right: 100),
                          child: Builder(
                            builder: (_) {
                              if (widget.showNurse) {
                                return TabBar(
                                  labelPadding: EdgeInsets.only(bottom: 2),
                                  controller: tabController,
                                  indicatorColor: Colors.white,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  tabs: [
                                    Text(orderStatus(info.status.toString())),
                                    Text('执行护工'),
                                  ],
                                );
                              }
                              return Center(
                                child: Text(
                                  orderStatus(info.status.toString()),
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: widget.showNurse ? [buildInfo(), buildNurseList()] : [buildInfo()],
                  ),
                )
              ],
            ),
          ),
          AnimatedPositioned(
            bottom: bottom,
            left: 0,
            right: 0,
            duration: Duration(milliseconds: 200),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.only(top: 16, right: 16, bottom: 32, left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: info.isRefund != 2 && info.userId == Global.userId,
                    child: OutlineButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => ChangeNotifierProvider<OrderProvider>.value(
                              value: Provider.of<OrderProvider>(context, listen: false),
                              child: Refund(),
                            ),
                          ),
                        );
                      },
                      child: Text(info.isRefund == 1 ? '查看退款' : '退款', style: TextStyles.black_14),
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
                    visible: info.isSettlement == 1,
                    child: FlatButton(
                      onPressed: () => OrderAction.settlement(
                        context: context,
                        orderId: info.orderId,
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
                    visible: info.userId == Global.userId,
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
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildInfo() {
    final info = Provider.of<OrderProvider>(context).info;
    final startDate = DateTime.parse(info.endTime);
    final endDate = DateTime.parse(info.startTime);
    final totalDay = startDate.difference(endDate).inDays;
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          Pannel(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F7F8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/img_location.png',
                        width: 16,
                        height: 16,
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${info.beNursed.realName} (${info.beNursed.phone})",
                            style: TextStyles.black_Bold_14,
                          ),
                          Text(
                            info.beNursed.identId,
                            style: TextStyles.grey_12,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                LabelValue(label: '服务地点', value: info.serverSite),
                SizedBox(height: 16),
                LabelValue(label: '顾客自理能力', value: info.selfCare),
              ],
            ),
          ),
          Pannel(
            child: Column(
              children: [
                Row(
                  children: [
                    Svgs.time2,
                    SizedBox(width: 4),
                    Text('时间', style: TextStyles.black_16),
                  ],
                ),
                SizedBox(height: 16),
                LabelValue(label: '顾客需要照护时间段', value: info.serverTime),
                SizedBox(height: 16),
                LabelValue(label: '服务日期', value: '${info.startTime} 至 ${info.endTime}'),
                SizedBox(height: 16),
                LabelValue(label: '服务天数', value: '$totalDay天'),
              ],
            ),
          ),
          Pannel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('备注', style: TextStyles.black_16),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        info.notes,
                        softWrap: true,
                      ),
                    ),
                    Visibility(
                      child: Text('暂无备注'),
                      visible: info.notes.length == 0,
                    ),
                  ],
                )
              ],
            ),
          ),
          Pannel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('订单信息', style: TextStyles.black_16),
                SizedBox(height: 16),
                LabelValue(
                  label: '订单价格',
                  value: "¥ ${info.amount}",
                  valueColor: ColorCenter.red,
                ),
                SizedBox(height: 16),
                LabelValue(label: '预约编号', value: info.id),
                SizedBox(height: 16),
                LabelValue(label: '订单编号', value: info.orderNumber),
                SizedBox(height: 16),
                LabelValue(label: '创建时间', value: info.createTime),
              ],
            ),
          ),
          SizedBox(height: 70)
        ],
      ),
    );
  }

  Widget buildNurseList() {
    final info = Provider.of<OrderProvider>(context).info;
    final nurseList = info.nurseList.map((e) => NurseItem(info: e, showAction: false)).toList();

    if (nurseList.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Svgs.emptyHolder,
          Text('还没有指派过护工哦～', style: TextStyles.grey_14),
        ],
      );
    }

    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [...nurseList],
      ),
    );
  }
}
