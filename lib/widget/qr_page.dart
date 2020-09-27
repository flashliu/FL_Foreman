import 'dart:async';
import 'dart:convert';

import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/models/user_model.dart';
import 'package:FL_Foreman/res/svgs.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_tools/qr_code_tools.dart';

class QrPage extends StatefulWidget {
  final Function success;
  QrPage({
    Key key,
    @required this.success,
  }) : super(key: key);

  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final picker = ImagePicker();
  bool lightOn = false;
  QRViewController controller;
  StreamSubscription<String> listner;

  scanFromCamera() async {
    try {
      final file = await picker.getImage(source: ImageSource.gallery);
      if (file != null) {
        String scanData = await QrCodeToolsPlugin.decodeFrom(file.path);
        Map<String, dynamic> jsonScanData = jsonDecode(scanData);
        final user = LoginUser.fromJson(jsonScanData);
        widget.success(user);
      }
    } catch (e) {
      ToastUtils.showLong('二维码识别失败');
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderLength: 10,
              borderWidth: 4,
              cutOutSize: 280,
            ),
          ),
          AppBar(
            backgroundColor: Colors.transparent,
            bottomOpacity: 0,
            leading: InkWell(
              child: Icon(Icons.close, color: Colors.white),
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            bottom: 56,
            left: 48,
            right: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.toggleFlash();
                    setState(() {
                      lightOn = !lightOn;
                    });
                  },
                  child: lightOn ? Svgs.closeLight : Svgs.light,
                ),
                // Svgs.closeLight,
                GestureDetector(
                  onTap: () => scanFromCamera(),
                  child: Svgs.photo,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    listner = controller.scannedDataStream.listen((scanData) {
      if (scanData != '') {
        listner.cancel();
        try {
          Map<String, dynamic> jsonScanData = jsonDecode(scanData);
          final user = LoginUser.fromJson(jsonScanData);
          widget.success(user);
        } catch (e) {
          print(e);
        }
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    listner?.cancel();
    super.dispose();
  }
}
