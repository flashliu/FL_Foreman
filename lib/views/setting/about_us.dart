import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/styles.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/widget/dot.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Stack(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              child: Image.asset(
                'assets/images/img_care.png',
                fit: BoxFit.cover,
              ),
            ),
            Align(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 60,
                  height: 40,
                  padding: EdgeInsets.all(7),
                  child: Svgs.back,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                ),
              ),
              alignment: Alignment.topLeft,
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 190),
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: kBoxDecorationStyle5,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        '关于我们',
                        style: TextStyles.black_Bold_16.copyWith(fontSize: 20),
                      ),
                    )
                  ],
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: kBoxDecorationStyle4.copyWith(color: ColorCenter.background),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Divider(
                            height: 30,
                            thickness: 3,
                            color: ColorCenter.blue,
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Dot(
                                  leftMargin: 0,
                                  width: 20,
                                  height: 20,
                                  dotColor: Colors.white,
                                ),
                                Text(
                                  '下单',
                                  style: TextStyles.black_14.copyWith(fontSize: 12),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Dot(
                                  width: 20,
                                  height: 20,
                                  dotColor: Colors.white,
                                ),
                                Text(
                                  '等待接单',
                                  style: TextStyles.black_14.copyWith(fontSize: 12),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Dot(
                                  width: 20,
                                  height: 20,
                                  dotColor: Colors.white,
                                ),
                                Text(
                                  '选择护工',
                                  style: TextStyles.black_14.copyWith(fontSize: 12),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Dot(
                                  leftMargin: 0,
                                  width: 20,
                                  height: 20,
                                  rightMargin: 0,
                                  dotColor: Colors.white,
                                ),
                                Text(
                                  '开始服务',
                                  style: TextStyles.black_14.copyWith(fontSize: 12),
                                )
                              ],
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "品牌介绍",
                        style: TextStyles.black_Bold_14,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 8, right: 9),
                      child: Text(
                        "        云南医护通科技（云南）有限责任公司是一家互联网+垂直化多元型一站式护理综合服务平台。公司成立于2019年，位于云南省昆明市高新区；由云南省生物医药大健康发展促进会牵头发起，联合云南本土80余家医疗机构、企事业单位、科研院所，吸纳全国顶尖生物、科技、医药、大健康领域企业及组织，携手众多国家级大健康领域专家教授共同创建",
                        style: TextStyles.grey_12,
                      ),
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "品牌使命",
                        style: TextStyles.black_Bold_14,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 8, right: 9),
                      child: Text(
                        "     公司秉承“陪护服务运营管理践行者”的企业使命，力造信息化一站式医护服务智能派工平台——医护工。平台建立智慧陪护服务模式，通过医养结合新模式，在地理区域、年龄层次、服务范围实现“全范围，全过程”的医养服务全覆盖。",
                        style: TextStyles.grey_12,
                      ),
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "云护工几大优势",
                        style: TextStyles.black_Bold_14,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 8, right: 9),
                      child: Text(
                        "云护工，打造全球医护服务体系建设一站式在线只能约单的全新模式。\n" +
                            "在线选择，一触即达；\n" +
                            "智能沟通，一键约单；\n" +
                            "护工经验，一目了然；\n" +
                            "服务品质，一诺千金；\n" +
                            "云护工，品质化护工服务一站到家。",
                        style: TextStyles.grey_12,
                      ),
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                GestureDetector(
                  onLongPress: () {
                    ToastUtils.showShort("请打开微信,搜索【护工云】");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/img_about.png'),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
