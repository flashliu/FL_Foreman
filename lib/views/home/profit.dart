import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Profit extends StatefulWidget {
  Profit({Key key}) : super(key: key);

  @override
  _ProfitState createState() => _ProfitState();
}

class _ProfitState extends State<Profit> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loaded();
  }

  void loaded() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: ColorCenter.background,
        padding: EdgeInsets.all(16),
        child: isLoading
            ? buildShimmer()
            : Column(
                children: [
                  Pannel(
                    child: Column(
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
                            Text('200,000.14', style: TextStyles.price),
                            Text('2,000', style: TextStyles.price.copyWith(fontWeight: FontWeight.normal)),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('本周进账'),
                            Text(
                              '12,000',
                              style: TextStyles.price.copyWith(fontWeight: FontWeight.normal, fontSize: 14),
                            )
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('今日进账'),
                            Text(
                              '12,000',
                              style: TextStyles.price.copyWith(fontWeight: FontWeight.normal, fontSize: 14),
                            )
                          ],
                        ),
                        Divider(
                          height: 30,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Svgs.wallet,
                                  SizedBox(width: 8),
                                  Text('我的账户'),
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
                        SizedBox(height: 10),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Svgs.coupon,
                                  SizedBox(width: 8),
                                  Text('我的卡券'),
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
                        SizedBox(height: 10),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Svgs.withdrawal,
                                  SizedBox(width: 8),
                                  Text('我要提现'),
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
                    ),
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
                                  '2400',
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
                                  '21',
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
                  Pannel(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '护工排行',
                              style: TextStyles.title.copyWith(fontSize: 18),
                            ),
                            Svgs.sort
                          ],
                        ),
                        SizedBox(height: 16),
                        buildNurseItem(),
                        buildNurseItem(),
                        buildNurseItem(),
                        buildNurseItem(),
                        buildNurseItem(),
                        buildNurseItem(),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Shimmer buildShimmer() {
    return Shimmer.fromColors(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 320,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              boxShadow: [BoxShadow(color: Colors.grey[100], blurRadius: 15)],
            ),
          ),
          Container(
            width: double.infinity,
            height: 100,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              boxShadow: [BoxShadow(color: Colors.grey[100], blurRadius: 15)],
            ),
          ),
          Container(
            width: double.infinity,
            height: 400,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              boxShadow: [BoxShadow(color: Colors.grey[100], blurRadius: 15)],
            ),
          )
        ],
      ),
      baseColor: Colors.grey[200],
      highlightColor: Colors.grey[50],
    );
  }

  Widget buildNurseItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            child: Image.asset('assets/images/avatar.png'),
          ),
          SizedBox(width: 16),
          Text(
            '护工姓名',
            style: TextStyles.title.copyWith(fontSize: 14),
          ),
          Expanded(
            child: Text(
              '129单',
              style: TextStyle(fontSize: 16, color: ColorCenter.textGrey),
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }
}
