import 'package:FL_Foreman/apis/nurse_api.dart';
import 'package:FL_Foreman/apis/order_api.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/models/need_model.dart';
import 'package:FL_Foreman/models/nurse_model.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/styles.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/views/my_order_list/my_order_list.dart';
import 'package:FL_Foreman/widget/checkable_nurse_item.dart';
import 'package:FL_Foreman/widget/label_value.dart';
import 'package:FL_Foreman/widget/list_content.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  TextEditingController textEditingController = TextEditingController();
  RefreshController refreshController = RefreshController();
  int page = 1;
  int pageSize = 5;
  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  Future<List<Nurse>> getNurseList({String keyworld = ''}) {
    return NurseApi.searchNurseListWithShare(
      keyworld,
      page: page,
      pageSize: pageSize,
    );
  }

  refresh({String keyworld = ''}) async {
    if (keyworld.isEmpty) textEditingController.clear();
    refreshController.resetNoData();
    page = 1;
    final res = await getNurseList(keyworld: keyworld);
    if (mounted) {
      setState(() {
        list = res;
        loading = false;
      });
    }
    if (res.length == 0) {
      refreshController.loadNoData();
    }
    refreshController.refreshCompleted();
  }

  loadMore() async {
    page++;
    final res = await getNurseList();
    setState(() {
      list = list + res;
    });
    if (res.length < pageSize) {
      return refreshController.loadNoData();
    }
    refreshController.loadComplete();
  }

  confirm() async {
    final res = await OrderApi.bindingNurse(
      bidMoney: widget.info.amount.toString(),
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

  assignNurse({@required String nurseId}) async {
    final res = await OrderApi.assignNurse(nurseId: nurseId, orderNum: widget.info.orderNumber);
    ToastUtils.showLong(res['message']);
    Global.eventBus.fire('refreshNeedList');
    if (res['code'] == 200) {
      Navigator.of(context).pop();
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
                          Text('订单价格', style: TextStyles.black_14.copyWith(fontSize: 12)),
                          Text('￥${widget.info.amount}', style: TextStyles.price.copyWith(fontSize: 16)),
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
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: kBoxDecorationStyle3,
                          height: 36,
                          child: TextField(
                            cursorColor: ColorCenter.themeColor,
                            controller: textEditingController,
                            style: TextStyles.black_14,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (_) => refresh(keyworld: textEditingController.value.text),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '请输入护工等级、姓名',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              suffixIcon: GestureDetector(
                                onTap: () => refresh(keyworld: textEditingController.value.text),
                                child: Icon(Icons.search, color: Colors.black54),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            list = list.reversed.toList();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Svgs.sort,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: buildNurseList(),
                ),
                Visibility(
                  visible: widget.info.orderNumber == null,
                  child: Container(
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
    return SmartRefresher(
      enablePullUp: list.length >= pageSize,
      header: WaterDropHeader(
        complete: Text('刷新成功！'),
        refresh: CupertinoActivityIndicator(),
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("上拉加载更多");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("加载失败");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("松开加载");
          } else {
            body = Text("没有更多数据");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      onRefresh: () => refresh(),
      onLoading: () => loadMore(),
      controller: refreshController,
      child: ListContent(
        itemBuilder: (BuildContext context, int index) {
          final checked = checkedNurse.indexOf(list[index].id) >= 0;
          return CheckabledNurseItem(
            info: list[index],
            checked: checked,
            onCheck: (info) {
              if (widget.info.orderNumber == null) {
                setState(() {
                  if (checked) {
                    checkedNurse.remove(info.id);
                  } else {
                    checkedNurse.add(info.id);
                  }
                });
              } else {
                assignNurse(nurseId: info.id);
              }
            },
          );
        },
        emptyText: '你暂时还没有护工，先去添加护工吧',
        itemCount: list.length,
      ),
    );
  }
}
