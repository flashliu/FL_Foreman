import 'package:FL_Foreman/apis/order_api.dart';
import 'package:FL_Foreman/models/order_model.dart';
import 'package:FL_Foreman/widget/list_content.dart';
import 'package:FL_Foreman/widget/order_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderPage extends StatefulWidget {
  final int status;
  final String nurseId;
  OrderPage({Key key, this.status, this.nurseId}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Order> list = [];
  bool loading = true;
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
    refreshController.dispose();
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
      page: page,
      pageSize: pageSize,
    );
  }

  refresh() async {
    page = 1;
    await Future.delayed(Duration(milliseconds: 300));
    final res = await getOrderList();
    if (mounted) {
      setState(() {
        list = res;
        loading = false;
      });
    }
    if (res.length == 0) refreshController.loadNoData();
    refreshController.refreshCompleted();
  }

  loadMore() async {
    page++;
    final res = await getOrderList();
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
      enablePullUp: refreshController.footerMode.value != LoadStatus.noMore,
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
          return OrderItem(
            info: list[index],
          );
        },
        itemCount: list.length,
        emptyText: "暂时没有内容～",
      ),
    );
  }
}
