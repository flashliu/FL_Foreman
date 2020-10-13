import 'package:FL_Foreman/widget/base_search_delegate.dart';
import 'package:flutter/material.dart';

class OrderSearchDelegate extends BaseSearchDelegate {
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
              start: now,
              end: now.add(Duration(days: 1)),
            ),
            locale: Locale('zh'),
            context: context,
            firstDate: DateTime(now.year, now.month - 1),
            lastDate: DateTime(now.year, now.month + 6, now.day + 1),
            confirmText: '确认',
          );
        },
      ),
    ];
  }
}
