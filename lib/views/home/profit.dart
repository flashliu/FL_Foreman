import 'package:FL_Foreman/apis/nurse_api.dart';
import 'package:FL_Foreman/apis/user_api.dart';
import 'package:FL_Foreman/models/nurse_model.dart';
import 'package:FL_Foreman/providers/user_provider.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profit extends StatefulWidget {
  Profit({Key key}) : super(key: key);

  @override
  _ProfitState createState() => _ProfitState();
}

class _ProfitState extends State<Profit> {
  String todayAmount = '0';
  String weekAmount = '0';
  String monthAmount = '0';
  List<Nurse> list = [];
  @override
  void initState() {
    super.initState();
    getAmout();
    getNurseList();
  }

  getNurseList() async {
    final data = await NurseApi.getNurseList('');
    if (this.mounted) {
      data.sort((a, b) => b.workTimes.compareTo(a.workTimes));
      setState(() {
        list = data;
      });
    }
  }

  getAmout() async {
    final res = await Future.wait([
      UserApi.getTodayAmount(),
      UserApi.getWeekAmount(),
      UserApi.getMonthAmount(),
    ]);
    if (mounted) {
      setState(() {
        todayAmount = res[0];
        weekAmount = res[1];
        monthAmount = res[2];
      });
    }
  }

  Widget buildNurseList() {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Pannel(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '护工排行',
                  style: TextStyles.title.copyWith(fontSize: 18),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      list = list.reversed.toList();
                    });
                  },
                  child: Svgs.sort,
                )
              ],
            ),
            SizedBox(height: 16),
            Visibility(
              visible: list.length == 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Svgs.emptyHolder,
                    Text(
                      "你还没有添加过护工，快去添加吧",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: list.map((e) => buildNurseItem(e)).toList(),
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          Pannel(
            child: buildAmountPannel(),
          ),
          Pannel(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '服务数据',
                    style: TextStyles.title.copyWith(fontSize: 18),
                  ),
                ),
                SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          list.map((e) => e.workTimes).fold(0, (p, n) => p + n).toString(),
                          style: TextStyle(
                            color: Color(0xFF00A2E6),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '服务单数',
                          style: TextStyle(color: ColorCenter.textBlack, fontSize: 12),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          list.length.toString(),
                          style: TextStyle(
                            color: Color(0xFF00A2E6),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '护工人数',
                          style: TextStyle(color: ColorCenter.textBlack, fontSize: 12),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          buildNurseList()
        ],
      ),
    );
  }

  Consumer<UserProvider> buildAmountPannel() {
    return Consumer<UserProvider>(
      builder: (context, user, child) {
        if (user.info == null) return Container();
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('我的资产', style: TextStyles.title.copyWith(fontSize: 18)),
                Svgs.eye,
              ],
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('账户余额'), Text('今日进账')],
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(user.info.loginUser.balance.toString(), style: TextStyles.price),
                Text(todayAmount, style: TextStyles.price.copyWith(fontWeight: FontWeight.normal)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('本周进账'),
                Text(
                  weekAmount,
                  style: TextStyles.price.copyWith(fontWeight: FontWeight.normal, fontSize: 14),
                )
              ],
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('本月进账'),
                Text(
                  monthAmount,
                  style: TextStyles.price.copyWith(fontWeight: FontWeight.normal, fontSize: 14),
                )
              ],
            ),
            // Divider(
            //   height: 30,
            // ),
            // Material(
            //   color: Colors.transparent,
            //   child: InkWell(
            //     borderRadius: BorderRadius.all(Radius.circular(8)),
            //     onTap: () {},
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(vertical: 2),
            //       child: Row(
            //         children: [
            //           Svgs.wallet,
            //           SizedBox(width: 8),
            //           Text('我的账户'),
            //           Expanded(
            //             child: Align(
            //               alignment: Alignment.centerRight,
            //               child: Icon(
            //                 Icons.keyboard_arrow_right,
            //                 color: ColorCenter.textGrey,
            //               ),
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 10),
            // Material(
            //   color: Colors.transparent,
            //   child: InkWell(
            //     borderRadius: BorderRadius.all(Radius.circular(8)),
            //     onTap: () {},
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(vertical: 2),
            //       child: Row(
            //         children: [
            //           Svgs.coupon,
            //           SizedBox(width: 8),
            //           Text('我的卡券'),
            //           Expanded(
            //             child: Align(
            //               alignment: Alignment.centerRight,
            //               child: Icon(
            //                 Icons.keyboard_arrow_right,
            //                 color: ColorCenter.textGrey,
            //               ),
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 10),
            // Material(
            //   color: Colors.transparent,
            //   child: InkWell(
            //     borderRadius: BorderRadius.all(Radius.circular(8)),
            //     onTap: () {},
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(vertical: 2),
            //       child: Row(
            //         children: [
            //           Svgs.withdrawal,
            //           SizedBox(width: 8),
            //           Text('我要提现'),
            //           Expanded(
            //             child: Align(
            //               alignment: Alignment.centerRight,
            //               child: Icon(
            //                 Icons.keyboard_arrow_right,
            //                 color: ColorCenter.textGrey,
            //               ),
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );
  }

  Widget buildNurseItem(Nurse info) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              info.headImg,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          Text(
            info.realName,
            style: TextStyles.title.copyWith(fontSize: 14),
          ),
          Expanded(
            child: Text(
              '${info.workTimes}单',
              style: TextStyle(fontSize: 16, color: ColorCenter.textGrey),
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }
}
