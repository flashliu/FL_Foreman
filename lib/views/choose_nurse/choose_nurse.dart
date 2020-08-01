import 'package:FL_Foreman/apis/nurse_api.dart';
import 'package:FL_Foreman/apis/order_api.dart';
import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/models/need_model.dart';
import 'package:FL_Foreman/models/nurse_model.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/views/my_order_list/my_order_list.dart';
import 'package:FL_Foreman/widget/checkable_nurse_item.dart';
import 'package:FL_Foreman/widget/label_value.dart';
import 'package:FL_Foreman/widget/list_content.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChooseNurse extends StatefulWidget {
  final Need info;
  ChooseNurse({Key key, @required this.info}) : super(key: key);

  @override
  _ChooseNurseState createState() => _ChooseNurseState();
}

class _ChooseNurseState extends State<ChooseNurse> {
  List<Nurse> list = [];
  bool loading = true;
  List<String> checkedNurse = [];
  @override
  void initState() {
    super.initState();
    getNurseList();
  }

  getNurseList() async {
    final data = await NurseApi.getNurseList('');
    await Future.delayed(Duration(seconds: 1));
    if (this.mounted) {
      setState(() {
        loading = false;
        list = data;
      });
    }
  }

  confirm() async {
    final res = await OrderApi.bindingNurse(
      bidMoney: (widget.info.price * double.parse(widget.info.totalTime)).toString(),
      needId: widget.info.id,
      userId: widget.info.userId,
      status: widget.info.status,
      nurseId: checkedNurse.join(','),
    );
    ToastUtils.showLong(res['message']);
    if (res['code'] == 200) {
      Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (_) => MyOrderList()));
    }
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
                        child: Align(
                          alignment: Alignment.center,
                          child: Transform.translate(
                            offset: Offset(-16, 0),
                            child: Text('选择护工', style: TextStyle(color: Colors.white, fontSize: 17)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Pannel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('生活照护', style: TextStyles.black_16),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('预计价格', style: TextStyles.black_14.copyWith(fontSize: 12)),
                          Text('￥130 /天', style: TextStyles.price.copyWith(fontSize: 16)),
                        ],
                      ),
                      SizedBox(height: 12),
                      LabelValue(
                        label: '服务地点',
                        value: widget.info.serverSite,
                        fontSize: 12,
                      ),
                      SizedBox(height: 12),
                      LabelValue(
                        label: '顾客需要照护时间段',
                        value: widget.info.serverTime,
                        fontSize: 12,
                      ),
                      SizedBox(height: 12),
                      LabelValue(
                        label: '服务时间',
                        value: '${widget.info.startTime} 至 ${widget.info.endTime}',
                        fontSize: 12,
                      ),
                      SizedBox(height: 12),
                      LabelValue(
                        label: '顾客自理能力',
                        value: widget.info.selfCare,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('选择护工', style: TextStyles.title),
                      Svgs.sort,
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: buildNurseList(),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white),
                  padding: EdgeInsets.only(bottom: 32, left: 16, right: 16),
                  child: FlatButton(
                    onPressed: checkedNurse.length > 0 ? confirm : null,
                    disabledColor: Colors.grey[300],
                    child: Text('确认（${checkedNurse.length}人）'),
                    color: ColorCenter.themeColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildNurseList() {
    if (loading) {
      return Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    }
    return ListContent(
      itemBuilder: (BuildContext context, int index) {
        final checked = checkedNurse.indexOf(list[index].id) >= 0;
        return CheckabledNurseItem(
          info: list[index],
          checked: checked,
          onCheck: (info) {
            setState(() {
              if (checked) {
                checkedNurse.remove(info.id);
              } else {
                checkedNurse.add(info.id);
              }
            });
          },
        );
      },
      emptyText: '你暂时还没有护工，先去添加护工吧',
      itemCount: list.length,
    );
  }
}
