import 'package:FL_Foreman/models/order_model.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  Order info;
  OrderProvider(this.info);

  setIsRefund(int value) {
    info.isRefund = value;
    notifyListeners();
  }

  setInfo(Order value) {
    info = value;
    notifyListeners();
  }
}
