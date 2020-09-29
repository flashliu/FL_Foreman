import 'package:FL_Foreman/models/foreman_model.dart';
import 'package:FL_Foreman/providers/style_provider.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/views/order_list/order_list.dart';
import 'package:FL_Foreman/views/order_list/order_page.dart';
import 'package:FL_Foreman/widget/foreman_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForemanDetail extends StatefulWidget {
  final Foreman info;
  ForemanDetail({Key key, @required this.info}) : super(key: key);

  @override
  _ForemanDetailState createState() => _ForemanDetailState();
}

class _ForemanDetailState extends State<ForemanDetail> with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabMaps.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            leading: InkWell(
              child: Icon(Icons.chevron_left),
              onTap: () => Navigator.of(context).pop(),
            ),
            title: Text('工头详情'),
            titleSpacing: 0,
            elevation: 0,
            expandedHeight: 320,
            flexibleSpace: FlexibleSpaceBar(
              background: ForemanItem(
                showAction: false,
                canGoDetail: false,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                info: widget.info,
                margin: EdgeInsets.only(top: 100),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 50),
              child: Container(
                width: double.infinity,
                color: ColorCenter.background,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TabBar(
                  isScrollable: true,
                  tabs: tabMaps
                      .map((e) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(e['text'])))
                      .toList(),
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: ColorCenter.themeColor,
                  labelColor: ColorCenter.themeColor,
                  unselectedLabelColor: Colors.black,
                  unselectedLabelStyle: TextStyles.black_Bold_14,
                  labelStyle: TextStyles.black_Bold_14,
                ),
              ),
            ),
          ),
        ],
        body: Provider(
          create: (context) => StyleProvider(
            listShowPaddingTop: false,
            showNurse: Provider.of<StyleProvider>(context, listen: false).showNurse,
          ),
          child: TabBarView(
            children: tabMaps
                .map((e) => OrderPage(
                      status: e['status'],
                      parentId: widget.info.id,
                    ))
                .toList(),
            controller: tabController,
          ),
        ),
      ),
    );
  }
}
