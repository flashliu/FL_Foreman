import 'package:FL_Foreman/models/nurse_model.dart';
import 'package:FL_Foreman/models/order_model.dart';
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

class OrderDetail extends StatefulWidget {
  final Order info;
  final int index;
  final bool showNurse;
  OrderDetail({Key key, @required this.info, this.index = 0, this.showNurse = true}) : super(key: key);

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
                                    Text(orderStatus(widget.info.status.toString())),
                                    Text('执行护工'),
                                  ],
                                );
                              }
                              return Center(
                                child: Text(
                                  orderStatus(widget.info.status.toString()),
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
                  OutlineButton(
                    onPressed: () {
                      Navigator.of(context).push(CupertinoPageRoute(builder: (_) => Refund(info: widget.info)));
                    },
                    child: Text('退款', style: TextStyles.black_14),
                    borderSide: BorderSide(width: 1, color: Colors.grey),
                    highlightedBorderColor: Colors.grey,
                    color: Colors.white,
                    textColor: ColorCenter.textBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  SizedBox(width: 8),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(CupertinoPageRoute(builder: (_) => CreateOrder()));
                    },
                    child: Text('再下一单', style: TextStyle(fontSize: 14)),
                    color: ColorCenter.themeColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
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
                            widget.info.beNursed.area.isEmpty ? '详细地址联系客户' : widget.info.beNursed.area,
                            style: TextStyles.black_Bold_14,
                          ),
                          Text(
                            widget.info.beNursed.realName,
                            style: TextStyles.grey_12,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                LabelValue(label: '服务地点', value: widget.info.serverSite),
                SizedBox(height: 16),
                LabelValue(label: '顾客自理能力', value: widget.info.selfCare),
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
                LabelValue(label: '顾客需要照护时间段', value: widget.info.serverTime),
                SizedBox(height: 16),
                LabelValue(label: '服务日期', value: '${widget.info.startTime} 至 ${widget.info.endTime}'),
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
                        widget.info.notes,
                        softWrap: true,
                      ),
                    ),
                    Visibility(
                      child: Text('暂无备注'),
                      visible: widget.info.notes.length == 0,
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
                LabelValue(label: '预约编号', value: widget.info.id),
                SizedBox(height: 16),
                LabelValue(label: '订单编号', value: widget.info.orderNumber),
                SizedBox(height: 16),
                LabelValue(label: '创建时间', value: widget.info.createTime),
              ],
            ),
          ),
          SizedBox(height: 70)
        ],
      ),
    );
  }

  Widget buildNurseList() {
    final nurseList = widget.info.nurseList.map((e) {
      final json = e.toJson();
      json['sex'] = json['sex'].toString();
      json['id'] = json['nurseId'];
      return NurseItem(
        info: Nurse.fromJson(json),
        showAction: false,
      );
    }).toList();

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
