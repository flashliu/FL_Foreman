import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OrderItem extends StatefulWidget {
  OrderItem({Key key}) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
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

  Widget buildShimmer() {
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
            SizedBox(height: 10),
            Container(color: Colors.grey[800], width: 150, height: 15),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nomalText = TextStyle(fontSize: 12, color: ColorCenter.textGrey);
    if (isLoading) return buildShimmer();
    return Pannel(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('生活照护', style: TextStyles.title),
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
                '2020.05.03 至 2020.07.12',
                style: TextStyle(fontSize: 14, color: ColorCenter.textBlack),
              ),
              Expanded(
                child: Text(
                  '白天(8:00 - 18:00)',
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
                  '昆明市-五华区-五华区医院',
                  style: nomalText,
                )
              ],
            ),
          ),
          Row(
            children: [
              Text('结束倒计时：2天 12:30:10', style: nomalText),
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
                      '2800',
                      style: TextStyles.price.copyWith(fontSize: 18),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('预约编号：218723162178', style: nomalText),
        ],
      ),
    );
  }
}
