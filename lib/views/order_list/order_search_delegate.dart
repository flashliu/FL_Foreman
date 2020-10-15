import 'package:FL_Foreman/apis/order_api.dart';
import 'package:FL_Foreman/widget/base_search_delegate.dart';
import 'package:FL_Foreman/widget/order_item.dart';
import 'package:FL_Foreman/widget/state_layout.dart';
import 'package:flutter/material.dart';

class OrderSearchDelegate extends BaseSearchDelegate {
  DateTime startTime;
  DateTime endTime;

  @override
  String get searchFieldLabel => '患者名字、身份证、电话、护工名字';

  @override
  TextStyle get searchFieldStyle => TextStyle(fontSize: 14);

  @override
  List<Widget> buildActions(BuildContext context) {
    final actions = super.buildActions(context);
    return [
      ...actions,
      IconButton(
        icon: Icon(
          Icons.sort,
        ),
        onPressed: () async {
          final now = DateTime.now();
          final res = await showDateRangePicker(
            builder: (context, child) {
              return Theme(
                data: ThemeData.dark(),
                child: child,
              );
            },
            initialDateRange: DateTimeRange(
              start: startTime ?? now,
              end: endTime ?? now.add(Duration(days: 1)),
            ),
            locale: Locale('zh'),
            context: context,
            firstDate: DateTime(now.year, now.month - 1),
            lastDate: DateTime(now.year, now.month + 6, now.day + 1),
            confirmText: '确认',
          );
          if (res is DateTimeRange) {
            startTime = res.start;
            endTime = res.end;
            // await Future.delayed(Duration(milliseconds: 500));
            showSuggestions(context);
            showResults(context);
          }
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: OrderApi.searchOrderList(
        keyWords: query,
        pageSize: 1000,
        startTime: startTime?.toString()?.substring(0, 10),
        endTime: endTime?.toString()?.substring(0, 10),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.length == 0) {
          return StateLayout(
            type: StateType.empty,
            hintText: '没有查询到数据',
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return OrderItem(
                info: snapshot.data[index],
              );
            },
            itemCount: snapshot.data.length,
          ),
        );
      },
    );
  }
}
