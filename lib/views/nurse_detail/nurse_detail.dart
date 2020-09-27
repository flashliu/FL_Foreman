import 'dart:convert';

import 'package:FL_Foreman/apis/user_api.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/models/nurse_model.dart';
import 'package:FL_Foreman/providers/style_provider.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/views/order_list/order_list.dart';
import 'package:FL_Foreman/widget/nurse_item.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
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
  final FijkPlayer player = FijkPlayer();
  String qrcode;
  @override
  void initState() {
    super.initState();
    setPlayer();
    tabController = TabController(length: 2, vsync: this);
    getQrcode();
  }

  getQrcode() async {
    String data = await UserApi.getMiniQrcode(page: 'pages/nurseDetail/index', id: widget.info.id);
    setState(() {
      qrcode = data;
    });
  }

  setPlayer() async {
    if (widget.info.nurseVideo.isNotEmpty) {
      await player.setDataSource(widget.info.nurseVideo, showCover: true);
    }
  }

  @override
  void dispose() {
    player.dispose();
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
    return SingleChildScrollView(
      child: Column(
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
                SizedBox(
                  width: double.infinity,
                  height: 170,
                  child: Builder(builder: (_) {
                    if (widget.info.nurseVideo.isEmpty) {
                      return Image.asset(
                        'assets/images/empty_video.png',
                        fit: BoxFit.cover,
                      );
                    }
                    return FijkView(
                      fit: FijkFit.cover,
                      player: player,
                      color: Colors.grey,
                      panelBuilder: fijkPanel2Builder(),
                    );
                  }),
                )
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
          ),
          Pannel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '小程序码',
                  style: TextStyles.black_Bold_16,
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: Builder(builder: (context) {
                    if (qrcode != null) {
                      return Column(
                        children: [
                          GestureDetector(
                            onLongPress: () => Global.saveQrcode(context, qrcode: qrcode),
                            child: SizedBox(
                              height: 200,
                              child: Image.memory(
                                Base64Decoder().convert(qrcode),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: CircularProgressIndicator(),
                    );
                  }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildOrderPage() {
    return Provider(
      create: (_) => StyleProvider(showNurse: false),
      child: OrderList(
        nurseId: widget.info.id,
        showAppbar: false,
      ),
    );
  }
}
