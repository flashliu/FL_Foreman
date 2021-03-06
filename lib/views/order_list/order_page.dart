import 'dart:async';

import 'package:FL_Foreman/apis/order_api.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/order_model.dart';
import 'package:FL_Foreman/widget/list_content.dart';
import 'package:FL_Foreman/widget/order_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderPage extends StatefulWidget {
  final int status;
  final String nurseId;
  final String parentId;
  OrderPage({
    Key key,
    this.status,
    this.nurseId,
    this.parentId,
  }) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with AutomaticKeepAliveClientMixin {
  List<Order> list = [];
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
      if (event == 'refreshOrderList') {
        refresh();
      }
    });
  }

  @override
  void dispose() {
    refreshController.dispose();
    listener?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(OrderPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) {
      loading = true;
      refresh();
    }
  }

  Future<List<Order>> getOrderList() async {
    return await OrderApi.getOrderList(
      status: widget.status,
      nurseId: widget.nurseId,
      parentId: widget.parentId,
      page: page,
      pageSize: pageSize,
    );
  }

  refresh() async {
    refreshController.resetNoData();
    page = 1;
    final res = await getOrderList();
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
    final res = await getOrderList();
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
          OrderItemShimmer(),
          OrderItemShimmer(),
          OrderItemShimmer(),
          OrderItemShimmer(),
        ],
      );
    }
    return SmartRefresher(
      enablePullUp: list.length >= pageSize,
      header: WaterDropHeader(
        complete: Text('???????????????'),
        refresh: CupertinoActivityIndicator(),
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("??????????????????");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("????????????");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("????????????");
          } else {
            body = Text("??????????????????");
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
          return OrderItem(
            info: list[index],
          );
        },
        itemCount: list.length,
        emptyText: "?????????????????????",
      ),
    );
  }
}
