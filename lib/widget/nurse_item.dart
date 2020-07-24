import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NurseItem extends StatefulWidget {
  final bool showLocation;
  NurseItem({Key key, this.showLocation = false}) : super(key: key);

  @override
  _NurseItemState createState() => _NurseItemState();
}

class _NurseItemState extends State<NurseItem> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceOut,
        reverseCurve: Curves.easeInOutBack,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  void didUpdateWidget(NurseItem oldWidget) {
    if (widget.showLocation != oldWidget.showLocation) {
      if (widget.showLocation) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        return Stack(
          children: [
            Positioned(
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFFDDE7EC),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '母婴护理',
                          style: TextStyles.title.copyWith(fontSize: 12),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/icon_location.png',
                              width: 12,
                              height: 12,
                            ),
                            Text(
                              '昆明市-五华区-第二人民医院',
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorCenter.textGrey,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Text(
                      '13:00 结束',
                      style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
                    )
                  ],
                ),
              ),
              bottom: animation.value * 16 + animation.value * -16 + 16,
              left: 16,
              right: 16,
            ),
            Pannel(
              margin: EdgeInsets.only(bottom: animation.value * 56 + 16),
              child: child,
            ),
          ],
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg',
              width: 72,
              height: 102,
              fit: BoxFit.fitHeight,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        showCupertinoModalPopup(
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
                        ).then((value) => {print(value)});
                      },
                      child: Svgs.menu),
                ),
                Row(
                  children: [
                    Text(
                      '李曼丽',
                      style: TextStyles.title,
                    ),
                    SizedBox(width: 8),
                    Svgs.start,
                    SizedBox(width: 4),
                    Text('4.9星', style: TextStyle(color: ColorCenter.textGrey, fontSize: 10))
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text('34岁', style: TextStyle(color: ColorCenter.textGrey, fontSize: 12)),
                    SizedBox(width: 4),
                    Image.asset(
                      'assets/images/icon_official.png',
                      width: 16,
                      height: 16,
                    )
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F7F8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFDAF4FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: EdgeInsets.all(4),
                          child: Text(
                            '二级护理',
                            style: TextStyle(
                              color: Color(0xFF00A2E6),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 4),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyles.price.copyWith(fontSize: 12),
                            children: [
                              TextSpan(text: '￥'),
                              TextSpan(
                                text: '140',
                                style: TextStyle(fontSize: 16),
                              ),
                              TextSpan(text: '/天'),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}