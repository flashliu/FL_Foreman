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

  @override
  void initState() {
    super.initState();
    getOrderList();
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
      getOrderList();
    }
  }

  getOrderList() async {
    final res = await OrderApi.getOrderList(
      status: widget.status,
      nurseId: widget.nurseId,
    );
    await Future.delayed(Duration(seconds: 1));
    if (mounted) {
      setState(() {
        list = res;
        loading = false;
      });
    }
    refreshController.refreshCompleted();
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
      header: WaterDropHeader(
        complete: Text('刷新成功！'),
        refresh: CupertinoActivityIndicator(),
      ),
      footer: ClassicFooter(),
      onRefresh: () => getOrderList(),
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
