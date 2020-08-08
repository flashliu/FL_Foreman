import 'package:FL_Foreman/models/nurse_model.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CheckabledNurseItem extends StatefulWidget {
  final Nurse info;
  final bool checked;
  final Function(Nurse info) onCheck;
  CheckabledNurseItem({
    Key key,
    this.info,
    this.checked = false,
    this.onCheck,
  }) : super(key: key);

  @override
  _CheckabledNurseItemState createState() => _CheckabledNurseItemState();
}

class _CheckabledNurseItemState extends State<CheckabledNurseItem> {
  @override
  Widget build(BuildContext context) {
    return Pannel(
      margin: const EdgeInsets.only(top: 32, left: 16, right: 16),
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 104),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.info.realName,
                          style: TextStyles.title,
                        ),
                        SizedBox(width: 8),
                        Text('34岁', style: TextStyle(color: ColorCenter.textGrey, fontSize: 12)),
                        SizedBox(width: 4),
                        Image.asset(
                          'assets/images/icon_official.png',
                          width: 16,
                          height: 16,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Svgs.start,
                              SizedBox(width: 4),
                              Text('4.9星', style: TextStyle(color: ColorCenter.textGrey, fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F7F8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFDAF4FF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: EdgeInsets.all(4),
                              child: Text(
                                widget.info.nurseLevel,
                                style: TextStyle(
                                  color: Color(0xFF00A2E6),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 4),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyles.price.copyWith(fontSize: 12),
                                children: [
                                  TextSpan(text: '￥'),
                                  TextSpan(
                                    text: '140',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  TextSpan(text: '/天'),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // SizedBox(height: 10),
                    FlatButton(
                      height: 32,
                      minWidth: 69,
                      onPressed: () => widget.onCheck(widget.info),
                      color: widget.checked ? Color(0xFFDAF4FF) : null,
                      textColor: widget.checked ? Color(0xFF00A2E6) : null,
                      child: Text('选ta'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: widget.checked ? Color(0xFF00A2E6) : ColorCenter.textGrey),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Positioned(
            // alignment: Alignment.centerLeft,
            left: 0,
            top: -32,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Builder(
                builder: (_) {
                  if (widget.info.headImg == null || widget.info.headImg.isEmpty) {
                    return Image.asset(
                      'assets/images/nurse_avatar.png',
                      width: 88,
                      height: 124,
                      fit: BoxFit.fitHeight,
                    );
                  }
                  return Image.network(
                    widget.info.headImg,
                    width: 88,
                    height: 124,
                    fit: BoxFit.fitHeight,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NurseItemShimmer extends StatelessWidget {
  const NurseItemShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Pannel(
      onTap: () {},
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200],
        highlightColor: Colors.grey[50],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 72,
              height: 102,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[800],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(color: Colors.grey[800], width: 20, height: 10),
                  ),
                  Container(color: Colors.grey[800], width: 120, height: 16),
                  SizedBox(height: 10),
                  Container(color: Colors.grey[800], width: 50, height: 16),
                  SizedBox(height: 10),
                  Container(color: Colors.grey[800], height: 25),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
