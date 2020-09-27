import 'package:FL_Foreman/apis/app_api.dart';
import 'package:FL_Foreman/apis/order_api.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/models/order_model.dart';
import 'package:FL_Foreman/models/refund_info.dart';
import 'package:FL_Foreman/res/colors.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/widget/label_value.dart';
import 'package:FL_Foreman/widget/pannel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Refund extends StatefulWidget {
  final Order info;
  Refund({Key key, this.info}) : super(key: key);

  @override
  _RefundState createState() => _RefundState();
}

class _RefundState extends State<Refund> {
  String refundAmount = '';
  String refundNumber = '';
  String refundNote = '';
  String reason = '';
  List<String> voucher = [];
  double refundDays;
  double totalDay;
  RefundInfo refundInfo;
  List<String> reasonList = [];
  bool showOther = false;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final startDate = DateTime.parse(widget.info.endTime);
    final endDate = DateTime.parse(widget.info.startTime);
    refundDays = totalDay = startDate.difference(endDate).inDays.toDouble();
    refundAmount = widget.info.amount.toString();
    getRefundInfo();
    getRefundReason();
  }

  getRefundInfo() async {
    final info = await OrderApi.getRefundInfo(widget.info.orderNumber);
    if (info != null) {
      setState(() {
        refundInfo = info;
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
    if (refundAmount.isEmpty) return ToastUtils.showLong('请填写退款金额');
    if (refundNumber.isEmpty) return ToastUtils.showLong('请填写退据单号');
    final res = await OrderApi.refund(
      orderAmout: widget.info.amount.toString(),
      orderNo: widget.info.orderNumber,
      refundAmout: refundAmount,
      refundDays: refundDays.toString(),
      refundNo: refundNumber,
      refundNote: refundNote == '其他' ? reason : refundNote,
      voucher: voucher.join(','),
    );

    if (res['code'] == 200) {
      getRefundInfo();
      user.setBalance();
      user.setAmount();
      Global.eventBus.fire('refreshOrderList');
    }
  }

  addVoucher() async {
    final way = await showCupertinoModalPopup<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          // message: Text('是否要删除当前项？'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('拍摄'),
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            CupertinoActionSheetAction(
              child: Text('从手机相册选择'),
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('cancel'),
            child: Text("取消"),
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
            child: Text('其他'),
            onPressed: () => Navigator.of(context).pop('其他'),
          ),
        );
      },
    );

    setState(() {
      refundNote = value;
      showOther = value == '其他';
    });
  }

  Widget buidSuccess() {
    return Column(
      children: [
        Pannel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('已退款至账号${refundInfo.username}，请注意查收', style: TextStyles.black_16),
              SizedBox(height: 16, width: double.infinity),
              Text(refundInfo.updateTime, style: TextStyles.grey_12)
            ],
          ),
        ),
        Pannel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('退款明细', style: TextStyles.black_16),
              SizedBox(height: 16),
              LabelValue(label: '退回至余额', value: "¥ ${refundInfo.refundAmout}"),
              SizedBox(height: 16),
              LabelValue(label: '退回时间', value: "实时到账"),
              SizedBox(height: 16),
              LabelValue(label: '处理时间', value: refundInfo.updateTime),
              SizedBox(height: 16),
              LabelValue(label: '订单编号', value: refundInfo.orderNo),
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
                  Text('订单信息', style: TextStyles.black_16),
                  SizedBox(height: 16),
                  LabelValue(label: '预约编号', value: widget.info.id),
                  SizedBox(height: 16),
                  LabelValue(label: '订单编号', value: widget.info.orderNumber),
                  SizedBox(height: 16),
                  LabelValue(label: '创建时间', value: widget.info.createTime),
                ],
              ),
            ),
            Pannel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('退款信息', style: TextStyles.black_16),
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
                            Text('退款原因', style: TextStyles.black_14),
                            SizedBox(width: 20),
                            Expanded(child: Text(refundNote.isEmpty ? '请选择' : refundNote, style: TextStyles.grey_14)),
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
                            hintText: '填写原因',
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
                        Text('退款金额', style: TextStyles.black_14),
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
                              hintText: "请输入退款金额",
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
                        Text('退据单号', style: TextStyles.black_14),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            initialValue: refundNumber,
                            onChanged: (value) {
                              refundNumber = value;
                            },
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "请输入退据单号",
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
                        Text('退款天数', style: TextStyles.black_14),
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
                  Text('上传凭证', style: TextStyles.black_16),
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
                child: Text('提交', style: TextStyle(fontSize: 14)),
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
                            child: Text('退款', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
