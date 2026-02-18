import 'package:flutter/material.dart';

enum BillingCycle { monthly, yearly }

class PlanProvider extends ChangeNotifier {
  BillingCycle _billingCycle = BillingCycle.monthly;

  BillingCycle get billingCycle => _billingCycle;

  void setBillingCycle(BillingCycle cycle) {
    _billingCycle = cycle;
    notifyListeners();
  }
}