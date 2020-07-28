import 'package:FL_Foreman/models/message_model.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/widget/dot.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  final Message info;
  const MessageItem({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Pannel(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                info.createTime,
                style: TextStyles.grey_14,
              ),
              Offstage(
                offstage: info.status == 0,
                child: Dot(
                  dotColor: ColorCenter.red,
                  height: 5,
                  width: 5,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            child: Text(
              info.content,
              style: TextStyles.black_14,
            ),
          )
        ],
      ),
    );
  }
}
