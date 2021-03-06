import 'package:FL_Foreman/apis/nurse_api.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/nurse_model.dart';
import 'package:FL_Foreman/providers/user_provider.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/views/reflect/reflect.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Profit extends StatefulWidget {
  Profit({Key key}) : super(key: key);

  @override
  _ProfitState createState() => _ProfitState();
}

class _ProfitState extends State<Profit> with AutomaticKeepAliveClientMixin {
  bool hideAmount = false;
  List<Nurse> list = [];
  RefreshController refreshController = RefreshController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    final userProvider = Global.userProvider;
    await Future.wait([
      userProvider.setBalance(),
      userProvider.setAmount(),
      userProvider.setWorkTimes(),
      userProvider.setTotalNurse(),
      getNurseList(),
    ]);
    refreshController.refreshCompleted();
  }

  Future getNurseList() async {
    final data = await NurseApi.getNurseList(nurseLevel: '');
    if (this.mounted) {
      data.sort((a, b) => b.workTimes.compareTo(a.workTimes));
      setState(() {
        list = data;
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
    super.build(context);
    return SmartRefresher(
      enablePullDown: true,
      header: WaterDropHeader(
        complete: Text('刷新成功！'),
        refresh: CupertinoActivityIndicator(),
      ),
      controller: refreshController,
      onRefresh: () => refresh(),
      child: SingleChildScrollView(
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
                  Consumer<UserProvider>(
                    builder: (context, user, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                user.workTimes,
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
                                user.totalNurse,
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
                      );
                    },
                  )
                ],
              ),
            ),
            buildNurseList()
          ],
        ),
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
                InkWell(
                  onTap: () {
                    setState(() {
                      hideAmount = !hideAmount;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Svgs.eye,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('账户余额'), Text('今日进账')],
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hideAmount ? '****' : user.balance,
                  style: TextStyles.price,
                ),
                Text(
                  hideAmount ? '****' : user.todayAmount,
                  style: TextStyles.price.copyWith(fontWeight: FontWeight.normal),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('本周进账'),
                Text(
                  hideAmount ? '****' : user.weekAmount,
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
                  hideAmount ? '****' : user.monthAmount,
                  style: TextStyles.price.copyWith(fontWeight: FontWeight.normal, fontSize: 14),
                )
              ],
            ),
            SizedBox(height: 10),
            Divider(),
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
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                onTap: () => Navigator.of(context).push(CupertinoPageRoute(builder: (_) => Reflect())),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Row(
                    children: [
                      Svgs.withdrawal,
                      SizedBox(width: 8),
                      Text('我要划付'),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: ColorCenter.textGrey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
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
          Builder(builder: (_) {
            if (info.headImg == null || info.headImg.isEmpty) {
              return ClipOval(
                child: Image.asset(
                  'assets/images/nurse_avatar.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              );
            }
            return ClipOval(
              child: Image.network(
                info.headImg,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            );
          }),
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
