import 'dart:async';

import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/need_model.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/views/choose_nurse/choose_nurse.dart';
import 'package:FL_Foreman/widget/label_value.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NeedDetail extends StatefulWidget {
  final Need info;
  NeedDetail({Key key, @required this.info}) : super(key: key);

  @override
  _NeedDetailState createState() => _NeedDetailState();
}

class _NeedDetailState extends State<NeedDetail> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.chevron_left),
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.info.demandName),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 16),
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
                                    widget.info.area.isEmpty ? '详细地址联系客户' : widget.info.area,
                                    style: TextStyles.black_Bold_14,
                                  ),
                                  Text(
                                    widget.info.realName,
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
                        LabelValue(label: '创建时间', value: widget.info.createTime),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyles.grey_14,
                        children: [
                          TextSpan(text: widget.info.peopleNumber.toString(), style: TextStyles.black_14),
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
              Divider(
                height: 1,
              ),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 32),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text(
                          '总收入￥${widget.info.price * int.parse(widget.info.totalTime)}',
                          style: TextStyles.price.copyWith(fontSize: 16),
                        ),
                        Text('￥${widget.info.price}/天', style: TextStyles.price.copyWith(fontSize: 12)),
                      ],
                    ),
                    SizedBox(width: 10),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(builder: (_) => ChooseNurse(info: widget.info)),
                      ),
                      child: Text('立即派单'),
                      color: ColorCenter.themeColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
