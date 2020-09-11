import 'dart:async';

import 'package:FL_Foreman/apis/order_api.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/need_model.dart';
import 'package:FL_Foreman/widget/list_content.dart';
import 'package:FL_Foreman/widget/need_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NeedPage extends StatefulWidget {
  final String site;
  NeedPage({Key key, this.site}) : super(key: key);

  @override
  _NeedPageState createState() => _NeedPageState();
}

class _NeedPageState extends State<NeedPage> with AutomaticKeepAliveClientMixin {
  List<Need> list = [];
  bool loading = true;
  RefreshController refreshController = RefreshController();
  int page = 1;
  int pageSize = 5;
  StreamSubscription listener;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    refresh();
    listener = Global.eventBus.on().listen((event) {
      print('refreshNeedList');
      if (event == 'refreshNeedList') {
        refresh();
      }
    });
  }

  @override
  void dispose() {
    refreshController.dispose();
    listener.cancel();
    super.dispose();
  }

  Future<List<Need>> getNeedList() {
    // if (widget.site == '推荐') {
    //   return OrderApi.getNeedSuggestList();
    // }
    // if (widget.site == '已付款') {
    //   return OrderApi.getNeedOtherList();
    // }

    if (widget.site == '医院') {
      return OrderApi.getNeedOtherList(page: page, pageSize: pageSize, parentId: Global.userId);
    }
    return OrderApi.getNeedOtherList(page: page, pageSize: pageSize);
    // return OrderApi.getNeedList(site: widget.site, page: page, pageSize: pageSize);
  }

  refresh() async {
    refreshController.resetNoData();
    page = 1;
    final res = await getNeedList();
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
    final res = await getNeedList();
    setState(() {
      list = list + res;
    });
    if (res.length < pageSize) {
      return refreshController.loadNoData();
    }
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loading) {
      return Wrap(
        children: [
          NeedItemShimmer(),
          NeedItemShimmer(),
          NeedItemShimmer(),
          NeedItemShimmer(),
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
          return NeedItem(
            info: list[index],
          );
        },
        itemCount: list.length,
        emptyText: "暂时没有内容～",
      ),
    );
  }
}
