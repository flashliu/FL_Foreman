import 'package:FL_Foreman/models/foreman_model.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/views/foreman_detail/foreman_detail.dart';
import 'package:FL_Foreman/views/nurse_detail/nurse_detail.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ForemanItem extends StatefulWidget {
  final Foreman info;
  final Function(Foreman foreman) onDelete;
  ForemanItem({Key key, @required this.info, this.onDelete}) : super(key: key);

  @override
  _ForemanItemState createState() => _ForemanItemState();
}

class _ForemanItemState extends State<ForemanItem> {
  List<Widget> buildNurseItem() {
    return widget.info.nurseList.map((item) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          children: [
            Positioned.fill(
              child: InkWell(
                onTap: () {
                  return Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => NurseDetail(
                        info: item,
                      ),
                    ),
                  );
                },
                child: Builder(builder: (_) {
                  if (item.headImg == null || item.headImg.isEmpty) {
                    return Image.asset(
                      'assets/images/nurse_avatar.png',
                      fit: BoxFit.cover,
                    );
                  }
                  return Image.network(
                    item.headImg,
                    fit: BoxFit.cover,
                  );
                }),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 18,
                width: double.infinity,
                alignment: Alignment.center,
                color: Color.fromRGBO(0, 0, 0, 0.4),
                child: Text(
                  item.realName,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            )
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Pannel(
      onTap: () => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (_) => ForemanDetail(
            info: widget.info,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Builder(builder: (_) {
                if (widget.info.headImg == null || widget.info.headImg.isEmpty) {
                  return ClipOval(
                    child: Image.asset(
                      'assets/images/avatar.png',
                      width: 72,
                      height: 72,
                    ),
                  );
                }
                return ClipOval(
                  child: Image.network(
                    widget.info.headImg,
                    width: 72,
                    height: 72,
                  ),
                );
              }),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.info.nickname ?? widget.info.username,
                  style: TextStyles.black_Bold_16,
                ),
              ),
              SizedBox(
                height: 72,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: InkWell(
                    onTap: () async {
                      final value = await showCupertinoModalPopup<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoActionSheet(
                            // message: Text('是否要删除当前项？'),
                            actions: <Widget>[
                              CupertinoActionSheetAction(
                                child: Text('删除'),
                                onPressed: () => Navigator.of(context).pop('delete'),
                                isDestructiveAction: true,
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () => Navigator.of(context).pop('cancel'),
                                child: Text("取消"),
                              ),
                            ],
                          );
                        },
                      );

                      if (value == 'delete') {
                        widget.onDelete(widget.info);
                      }
                    },
                    child: Svgs.menu,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 16),
          Text('我的护工', style: TextStyles.black_Bold_14.copyWith(fontSize: 12)),
          SizedBox(height: 8),
          SizedBox(
            height: 67,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 18,
                childAspectRatio: 67 / 48,
              ),
              scrollDirection: Axis.horizontal,
              children: [
                ...buildNurseItem(),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color(0xFFF5F7F8),
                    border: Border.all(color: Color(0xFFDDDDDD)),
                  ),
                  child: Text(
                    '查看更多',
                    style: TextStyle(color: Color(0xFF00A2E6), fontSize: 10),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ForemanItemShimmer extends StatelessWidget {
  const ForemanItemShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Pannel(
      onTap: () {},
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200],
        highlightColor: Colors.grey[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(width: 16),
                Container(color: Colors.grey[800], width: 80, height: 25),
                Spacer(),
                SizedBox(
                  height: 72,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(color: Colors.grey[800], width: 20, height: 10),
                  ),
                )
              ],
            ),
            SizedBox(height: 16),
            Container(color: Colors.grey[800], width: 80, height: 16),
            SizedBox(height: 8),
            Row(
              children: [
                Container(color: Colors.grey[800], width: 48, height: 67),
                SizedBox(width: 18),
                Container(color: Colors.grey[800], width: 48, height: 67),
                SizedBox(width: 18),
                Container(color: Colors.grey[800], width: 48, height: 67),
                SizedBox(width: 18),
                Container(color: Colors.grey[800], width: 48, height: 67),
                SizedBox(width: 18),
                Container(color: Colors.grey[800], width: 48, height: 67),
              ],
            )
          ],
        ),
      ),
    );
  }
}
