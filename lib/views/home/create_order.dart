import 'package:FL_Foreman/apis/order_api.dart';
import 'package:FL_Foreman/common/dialog_util.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/common/input_formatter.dart';
import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/widget/label_value.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateOrder extends StatefulWidget {
  CreateOrder({Key key}) : super(key: key);

  @override
  _CreateOrderState createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idcardController = TextEditingController();
  TextEditingController depositController = TextEditingController();
  TextEditingController unitPriceController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  DateTimeRange dateTimeRange;
  List<String> orderTypes = ['医院', '线上订单'];
  int orderType = 0;
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    depositController.addListener(() {
      setState(() {});
    });
    dateTimeRange = DateTimeRange(
      start: now.add(Duration(days: 1)),
      end: now.add(Duration(days: 2)),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    idcardController.dispose();
    depositController.dispose();
    unitPriceController.dispose();
    notesController.dispose();
    super.dispose();
  }

  submit() async {
    final phone = phoneController.value.text;
    final idCard = idcardController.value.text.toUpperCase();
    final name = nameController.value.text;
    final amount = depositController.value.text;
    final preferPrice = unitPriceController.value.text;
    if (name.isEmpty) return ToastUtils.showShort("请输入被护理人姓名！");
    if (!RegexUtil.isMobileExact(phone)) return ToastUtils.showShort("请输入正确的电话！");
    if (!RegexUtil.isIDCard(idCard)) return ToastUtils.showShort("请输入正确的身份证号！");
    if (amount.isEmpty) return ToastUtils.showShort("请输入押金！");
    if (double.tryParse(amount) == null) return ToastUtils.showShort("请输入正确的押金！");
    if (preferPrice.isEmpty) return ToastUtils.showShort("请输入每日单价！");
    if (double.tryParse(preferPrice) == null) return ToastUtils.showShort("请输入正确的每日单价！");
    DialogUtils.showLoading(context: context, msg: '下单中');

    final res = await OrderApi.createOrder(
      beNurseCard: idCard,
      beNurseName: name,
      beNursePhone: phone,
      startTime: dateTimeRange.start.toString().substring(0, 10),
      endTime: dateTimeRange.end.toString().substring(0, 10),
      remark: notesController.value.text,
      amount: amount,
      preferPrice: preferPrice,
      orderType: orderType,
    );
    DialogUtils.hideLoading(context);
    if (res['code'] == 200) {
      final qr = await OrderApi.getPayQrcode(res['data']['id']);
      await DialogUtils.showQrPay(context: context, qr: qr);
      Global.eventBus.fire('refreshNeedList');
      return Navigator.of(context).pop();
    }

    ToastUtils.showShort(res['message']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.chevron_left),
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text('添加下单'),
        titleSpacing: 0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Pannel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('选择护工', style: TextStyles.title),
                          SizedBox(height: 16),
                          LabelValue(label: '服务地点', value: '医院'),
                          SizedBox(height: 12),
                          LabelValue(label: '顾客自理能力', value: '自理'),
                          // SizedBox(height: 12),
                          // LabelValue(label: '顾客需要照护时间段', value: '白天(8:00 - 20:00)'),
                        ],
                      ),
                    ),
                    Pannel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('订单类型', style: TextStyles.title),
                          SizedBox(height: 16),
                          InkWell(
                            onTap: () async {
                              final val = await showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoActionSheet(
                                    // message: Text('是否要删除当前项？'),
                                    actions: orderTypes
                                        .asMap()
                                        .map(
                                          (key, value) => MapEntry(
                                            key,
                                            CupertinoActionSheetAction(
                                              child: Text(value),
                                              onPressed: () => Navigator.of(context).pop(key),
                                            ),
                                          ),
                                        )
                                        .values
                                        .toList(),
                                    cancelButton: CupertinoActionSheetAction(
                                      onPressed: () => Navigator.of(context).pop(null),
                                      child: Text('取消'),
                                      isDestructiveAction: true,
                                    ),
                                  );
                                },
                              );
                              if (val == null) return;
                              setState(() {
                                orderType = val;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F7F8),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(orderTypes[orderType]),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: ColorCenter.textBlack,
                                    size: 12,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Pannel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('被护理人信息', style: TextStyles.title),
                          SizedBox(height: 16),
                          buildInput('被护理人姓名', controller: nameController),
                          SizedBox(height: 12),
                          buildInput('电话', controller: phoneController, keyboardType: TextInputType.phone),
                          SizedBox(height: 12),
                          buildInput('身份证号', controller: idcardController),
                        ],
                      ),
                    ),
                    Pannel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('服务时间', style: TextStyles.title),
                          SizedBox(height: 16),
                          InkWell(
                            onTap: () async {
                              final res = await showDateRangePicker(
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.dark(),
                                    child: child,
                                  );
                                },
                                initialDateRange: dateTimeRange,
                                locale: Locale('zh'),
                                context: context,
                                firstDate: DateTime(now.year, now.month - 1),
                                lastDate: DateTime(now.year, now.month + 6, now.day + 1),
                              );
                              if (res != null) {
                                setState(() {
                                  dateTimeRange = res;
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F7F8),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${dateTimeRange.start.toString().substring(0, 10)} 至 ${dateTimeRange.end.toString().substring(0, 10)}',
                                    ),
                                  ),
                                  Text(
                                    '共${dateTimeRange.end.difference(dateTimeRange.start).inDays}天',
                                    style: TextStyles.grey_12,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: ColorCenter.textBlack,
                                    size: 12,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Pannel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('押金', style: TextStyles.title),
                          SizedBox(height: 16),
                          buildInput(
                            '请输入',
                            controller: depositController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("^[1-9].*")),
                              FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                              MoneyTextInputFormatter(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Pannel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('每日单价', style: TextStyles.title),
                          SizedBox(height: 16),
                          buildInput(
                            '请输入',
                            controller: unitPriceController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("^[1-9].*")),
                              FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                              MoneyTextInputFormatter(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Pannel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('备注', style: TextStyles.title),
                              SizedBox(width: 8),
                              Text('非必填', style: TextStyles.grey_12),
                            ],
                          ),
                          SizedBox(height: 16),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 80),
                            child: TextField(
                              controller: notesController,
                              maxLines: 4,
                              style: TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(6),
                                  ),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF5F7F8),
                                hintStyle: TextStyle(color: Color(0xFF999999)),
                                hintText: '请填写备注',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 32),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Text(
                        '价格 ￥${depositController.text.isEmpty ? '0.00' : depositController.text}',
                        style: TextStyles.price.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  FlatButton(
                    onPressed: () => submit(),
                    child: Text('提交订单'),
                    color: ColorCenter.themeColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ConstrainedBox buildInput(
    String hintText, {
    TextEditingController controller,
    TextInputType keyboardType,
    List<TextInputFormatter> inputFormatters,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 40),
      child: TextField(
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        controller: controller,
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: const BorderRadius.all(
              const Radius.circular(6),
            ),
          ),
          filled: true,
          fillColor: Color(0xFFF5F7F8),
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xFF999999)),
        ),
      ),
    );
  }
}
