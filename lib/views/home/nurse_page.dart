import 'package:FL_Foreman/apis/nurse_api.dart';
import 'package:FL_Foreman/models/nurse_model.dart';
import 'package:FL_Foreman/widget/list_content.dart';
import 'package:FL_Foreman/widget/nurse_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NursePage extends StatefulWidget {
  final String level;
  final bool showLocation;
  NursePage({Key key, this.level, this.showLocation = false}) : super(key: key);

  @override
  _NursePageState createState() => _NursePageState();
}

class _NursePageState extends State<NursePage> with AutomaticKeepAliveClientMixin {
  List<Nurse> list = [];
  bool loading = true;
  RefreshController refreshController = RefreshController();
  int page = 1;
  int pageSize = 10;

  @override
  bool get wantKeepAlive => true;

  Future<List<Nurse>> getNurseList() async {
    return NurseApi.getNurseList(nurseLevel: widget.level, page: page, pageSize: pageSize);
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    page = 1;
    await Future.delayed(Duration(milliseconds: 300));
    final res = await getNurseList();
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
    if (res.length < pageSize) {
      return refreshController.loadNoData();
    }
    setState(() {
      list = list + res;
    });
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (loading) {
      return Wrap(
        children: [
          NurseItemShimmer(),
          NurseItemShimmer(),
          NurseItemShimmer(),
          NurseItemShimmer(),
          NurseItemShimmer(),
        ],
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
        itemBuilder: (context, index) {
          return NurseItem(
            info: list[index],
            showLocation: widget.showLocation,
          );
        },
        itemCount: list.length,
        emptyText: "暂时没有内容～",
      ),
    );
  }
}