import 'dart:async';

import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/nurse_model.dart';
import 'package:FL_Foreman/models/order_model.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/widget/label_value.dart';
import 'package:FL_Foreman/widget/nurse_item.dart';
import 'package:FL_Foreman/widget/order_item.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/material.dart';

class OrderDetail extends StatefulWidget {
  final Order info;
  OrderDetail({Key key, @required this.info}) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> with SingleTickerProviderStateMixin {
  TabController tabController;
  double bottom = 0;
  CountDown countDown = CountDown(day: '00', hour: '00', min: '00', sec: '00');
  Timer timer;

  @override
  void initState() {
    super.initState();
    setCountDown();
    tabController = TabController(length: 2, vsync: this)
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
    tabController.dispose();
    timer?.cancel();
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
                          child: TabBar(
                            labelPadding: EdgeInsets.only(bottom: 2),
                            controller: tabController,
                            indicatorColor: Colors.white,
                            indicatorSize: TabBarIndicatorSize.label,
                            tabs: [
                              Text(orderStatus(widget.info.status.toString())),
                              Text('我的护工'),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [buildInfo(), buildNurseList()],
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyles.grey_14,
                      children: [
                        TextSpan(text: widget.info.nurseList.length.toString(), style: TextStyles.black_14),
                        TextSpan(text: '人抢单'),
                      ],
                    ),
                  ),
                  Text(
                    '结束倒计时：${countDown.day}天 ${countDown.hour}:${countDown.min}:${countDown.sec}',
                    style: TextStyle(color: Color(0xFF00A2E6), fontSize: 12),
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
    return Column(
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
                          widget.info.beNursed.area,
                          style: TextStyle(color: ColorCenter.textBlack),
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
                  Text(widget.info.notes),
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
              LabelValue(label: '创建时间', value: widget.info.createTime),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildNurseList() {
    final nurseList = widget.info.nurseList.map((e) {
      final json = e.toJson();
      json['sex'] = json['sex'].toString();
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
      child: Column(
        children: [...nurseList],
      ),
    );
  }
}
