import 'package:FL_Foreman/models/nurse_model.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/views/my_order_list/my_order_list.dart';
import 'package:FL_Foreman/views/my_order_list/order_page.dart';
import 'package:FL_Foreman/widget/nurse_item.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NurseDetail extends StatefulWidget {
  final Nurse info;
  NurseDetail({Key key, this.info}) : super(key: key);

  @override
  _NurseDetailState createState() => _NurseDetailState();
}

class _NurseDetailState extends State<NurseDetail> with SingleTickerProviderStateMixin {
  TabController tabController;
  int status = 0;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.chevron_left),
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text('护工详情'),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          NurseItem(
            info: widget.info,
            margin: EdgeInsets.all(0),
            showAction: false,
            canGoDetail: false,
            borderRadius: BorderRadius.circular(0),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            child: TabBar(
              indicatorColor: ColorCenter.themeColor,
              labelColor: ColorCenter.themeColor,
              unselectedLabelColor: Colors.black,
              unselectedLabelStyle: TextStyles.black_14,
              labelStyle: TextStyles.black_14,
              controller: tabController,
              // indicatorSize: TabBarIndicatorSize.tab - 10,
              tabs: [
                Text('详情'),
                Text('订单'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                buildDetailPage(),
                buildOrderPage(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildDetailPage() {
    return Column(
      children: [
        SizedBox(height: 16),
        Pannel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '视频介绍',
                style: TextStyles.black_Bold_16,
              ),
              SizedBox(height: 16),
              Image.asset('assets/images/empty_video.png')
            ],
          ),
        ),
        Pannel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '用户评价',
                style: TextStyles.black_Bold_16,
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: Text('暂时还没有评价，期待您的评价~'),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildOrderPage() {
    return Column(
      children: [
        DefaultTabController(
          length: 6,
          child: TabBar(
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: ColorCenter.themeColor,
            labelColor: ColorCenter.themeColor,
            unselectedLabelColor: Colors.black,
            unselectedLabelStyle: TextStyles.black_Bold_14,
            labelStyle: TextStyles.black_Bold_14,
            tabs: tabMaps
                .map((e) => Padding(padding: const EdgeInsets.only(top: 10, bottom: 4), child: Text(e['text'])))
                .toList(),
            onTap: (index) {
              final value = tabMaps.toList()[index]['status'];
              setState(() {
                status = value;
              });
            },
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: Provider<bool>.value(
            value: false,
            child: OrderPage(status: status, nurseId: widget.info.id),
          ),
        )
      ],
    );
  }
}
