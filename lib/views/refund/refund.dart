import 'package:FL_Foreman/apis/app_api.dart';
import 'package:FL_Foreman/apis/order_api.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/models/refund_info.dart';
import 'package:FL_Foreman/providers/order_provider.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/widget/label_value.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Refund extends StatefulWidget {
  Refund({Key key}) : super(key: key);

  @override
  _RefundState createState() => _RefundState();
}

class _RefundState extends State<Refund> {
  String refundAmount = '';
  String refundNumber = '';
  String phone = '';
  String code = '';
  String refundNote = '';
  String reason = '';
  List<String> voucher = [];
  double refundDays;
  double totalDay;
  RefundInfo refundInfo;
  List<String> reasonList = [];
  bool showOther = false;
  OrderProvider orderProvider;
  final picker = ImagePicker();

  @override
  void initState() {
    orderProvider = Provider.of<OrderProvider>(context, listen: false);
    super.initState();
    final startDate = DateTime.parse(orderProvider.info.endTime);
    final endDate = DateTime.parse(orderProvider.info.startTime);
    refundDays = totalDay = startDate.difference(endDate).inDays.toDouble();
    refundAmount = orderProvider.info.amount.toString();
    getRefundInfo();
    getRefundReason();
  }

  getRefundInfo() async {
    final info = Provider.of<OrderProvider>(context, listen: false).info;
    final res = await OrderApi.getRefundInfo(info.orderNumber);
    if (res != null) {
      setState(() {
        refundInfo = res;
      });
    }
  }

  getRefundReason() async {
    final list = await OrderApi.getRefundReason();
    setState(() {
      reasonList = list;
    });
  }

  submit() async {
    final user = Global.userProvider;
    final note = refundNote == '??????' ? reason : refundNote;
    if (note.isEmpty) return ToastUtils.showLong('?????????????????????');
    if (refundAmount.isEmpty) return ToastUtils.showLong('?????????????????????');
    if (phone.isEmpty) return ToastUtils.showLong('????????????????????????');
    if (!RegexUtil.isMobileExact(phone)) return ToastUtils.showLong('???????????????????????????');
    if (code.isEmpty) return ToastUtils.showLong('??????????????????');

    final res = await OrderApi.refund(
      orderAmout: orderProvider.info.amount.toString(),
      orderNo: orderProvider.info.orderNumber,
      refundAmout: refundAmount,
      refundDays: refundDays.toString(),
      refundNo: refundNumber,
      refundNote: note,
      voucher: voucher.join(','),
      phone: phone,
      code: code,
    );

    if (res['code'] == 200) {
      getRefundInfo();
      user.setBalance();
      user.setAmount();
      Global.eventBus.fire('refreshOrderList');
      orderProvider.setIsRefund(1);
    }
  }

  addVoucher() async {
    final way = await showCupertinoModalPopup<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          // message: Text('???????????????????????????'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('??????'),
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            CupertinoActionSheetAction(
              child: Text('?????????????????????'),
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('cancel'),
            child: Text("??????"),
          ),
        );
      },
    );
    if (way is ImageSource) {
      final file = await picker.getImage(source: way);
      if (file == null) return;
      final src = await AppApi.upload(file.path);
      setState(() {
        voucher.add(src);
      });
    }
  }

  chooseReason() async {
    final value = await showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: reasonList
              .map(
                (e) => CupertinoActionSheetAction(
                  child: Text(e),
                  onPressed: () => Navigator.of(context).pop(e),
                ),
              )
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            child: Text('??????'),
            onPressed: () => Navigator.of(context).pop('??????'),
          ),
        );
      },
    );

    if (value != null) {
      setState(() {
        refundNote = value;
        showOther = value == '??????';
      });
    }
  }

  Widget buidSuccess() {
    return Column(
      children: [
        Pannel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('??????????????????${refundInfo.refundphone ?? refundInfo.nickname}??????????????????', style: TextStyles.black_16),
              SizedBox(height: 16, width: double.infinity),
              Text(refundInfo.updateTime, style: TextStyles.grey_12)
            ],
          ),
        ),
        Pannel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('????????????', style: TextStyles.black_16),
              SizedBox(height: 16),
              LabelValue(label: '???????????????', value: "?? ${refundInfo.refundAmout}"),
              SizedBox(height: 16),
              LabelValue(label: '????????????', value: "????????????"),
              SizedBox(height: 16),
              LabelValue(label: '????????????', value: refundInfo.updateTime),
              SizedBox(height: 16),
              LabelValue(label: '????????????', value: refundInfo.orderNo),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildForm() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Pannel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('????????????', style: TextStyles.black_16),
                  SizedBox(height: 16),
                  LabelValue(label: '????????????', value: orderProvider.info.id),
                  SizedBox(height: 16),
                  LabelValue(label: '????????????', value: orderProvider.info.orderNumber),
                  SizedBox(height: 16),
                  LabelValue(label: '????????????', value: orderProvider.info.createTime),
                ],
              ),
            ),
            Pannel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('????????????', style: TextStyles.black_16),
                  SizedBox(height: 16),
                  Material(
                    color: ColorCenter.background,
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () => chooseReason(),
                      child: Container(
                        height: 46,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Text('????????????', style: TextStyles.black_14),
                            SizedBox(width: 20),
                            Expanded(child: Text(refundNote.isEmpty ? '?????????' : refundNote, style: TextStyles.grey_14)),
                            Icon(
                              Icons.chevron_right,
                              color: ColorCenter.textGrey,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Visibility(
                    visible: showOther,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 80),
                        child: TextField(
                          onChanged: (value) => reason = value,
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
                            hintText: '????????????',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 46,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: ColorCenter.background,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Text('????????????', style: TextStyles.black_14),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            initialValue: refundAmount,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            onChanged: (value) {
                              refundAmount = value;
                            },
                            style: TextStyle(color: ColorCenter.red, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "?????????????????????",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 46,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: ColorCenter.background,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Text('?????????', style: TextStyles.black_14),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            initialValue: phone,
                            onChanged: (value) {
                              phone = value;
                            },
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "????????????????????????",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 46,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: ColorCenter.background,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Text('?????????', style: TextStyles.black_14),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            initialValue: code,
                            onChanged: (value) {
                              code = value;
                            },
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "??????????????????",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 46,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: ColorCenter.background,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Text('????????????', style: TextStyles.black_14),
                        SizedBox(width: 20),
                        FlatButton(
                          onPressed: () {
                            if (refundDays <= 0.5) return;
                            setState(() {
                              refundDays = refundDays - 0.5;
                            });
                          },
                          child: Icon(Icons.remove),
                          minWidth: 25,
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              refundDays.toString(),
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            if (refundDays >= totalDay) return;
                            setState(() {
                              refundDays = refundDays + 0.5;
                            });
                          },
                          child: Icon(Icons.add),
                          minWidth: 25,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Pannel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('????????????', style: TextStyles.black_16),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      children: [
                        ...voucher.map(
                          (src) => ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              src,
                              fit: BoxFit.cover,
                              width: 76,
                              height: 76,
                            ),
                          ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(6),
                          color: ColorCenter.background,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () => addVoucher(),
                            child: Container(
                              width: 76,
                              height: 76,
                              child: Icon(
                                Icons.add_circle_outline,
                                color: ColorCenter.textBlack,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FlatButton(
                minWidth: double.infinity,
                height: 46,
                onPressed: () => submit(),
                child: Text('??????', style: TextStyle(fontSize: 14)),
                color: ColorCenter.themeColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Container(
              height: 164,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.75, 1],
                  colors: [Color(0xFF0C9AE0), Color.fromRGBO(66, 193, 247, 0)],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 50),
                            child: Text('??????', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  Builder(builder: (context) {
                    if (refundInfo == null) {
                      return buildForm();
                    }
                    return buidSuccess();
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
