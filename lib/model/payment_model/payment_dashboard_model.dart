class PaymentDashboardResponse {
  final bool success;
  final int count;
  final int total;
  final int page;
  final int pages;
  final PaymentStats stats;
  final List<RentPayment> data;

  PaymentDashboardResponse({
    required this.success,
    required this.count,
    required this.total,
    required this.page,
    required this.pages,
    required this.stats,
    required this.data,
  });

  factory PaymentDashboardResponse.fromJson(Map<String, dynamic> json) {
    return PaymentDashboardResponse(
      success: json['success'],
      count: json['count'],
      total: json['total'],
      page: json['page'],
      pages: json['pages'],
      stats: PaymentStats.fromJson(json['stats']),
      data: (json['data'] as List).map((e) => RentPayment.fromJson(e)).toList(),
    );
  }
}

class PaymentStats {
  final int total;
  final int pending;
  final int partial;
  final int paid;
  final int overdue;
  final num totalExpected;
  final num totalCollected;
  final num pendingAmount;

  PaymentStats({
    required this.total,
    required this.pending,
    required this.partial,
    required this.paid,
    required this.overdue,
    required this.totalExpected,
    required this.totalCollected,
    required this.pendingAmount,
  });

  factory PaymentStats.fromJson(Map<String, dynamic> json) {
    return PaymentStats(
      total: json['total'],
      pending: json['pending'],
      partial: json['partial'],
      paid: json['paid'],
      overdue: json['overdue'],
      totalExpected: json['totalExpected'],
      totalCollected: json['totalCollected'],
      pendingAmount: json['pendingAmount'],
    );
  }
}

class RentPayment {
  final String id;
  final String paymentNumber;
  final String status;
  final BillingPeriod billingPeriod;
  final Amounts amounts;
  final PaymentInfo payment;
  final PaymentDates dates;
  final LateFeeCalculation lateFeeCalculation;
  final ReceiptInfo receipt;
  final Tenant tenant;
  final Property property;
  final Room room;
  final GeneratedBy? generatedBy;
  final String? notes;
  final List<TimelineEntry> timeline;

  RentPayment({
    required this.id,
    required this.paymentNumber,
    required this.status,
    required this.billingPeriod,
    required this.amounts,
    required this.payment,
    required this.dates,
    required this.lateFeeCalculation,
    required this.receipt,
    required this.tenant,
    required this.property,
    required this.room,
    this.generatedBy,
    this.notes,
    required this.timeline,
  });

  factory RentPayment.fromJson(Map<String, dynamic> json) {
    return RentPayment(
      id: json['_id'],
      paymentNumber: json['paymentNumber'],
      status: json['status'],
      billingPeriod: BillingPeriod.fromJson(json['billingPeriod']),
      amounts: Amounts.fromJson(json['amounts']),
      payment: PaymentInfo.fromJson(json['payment']),
      dates: PaymentDates.fromJson(json['dates']),
      lateFeeCalculation: LateFeeCalculation.fromJson(
        json['lateFeeCalculation'],
      ),
      receipt: ReceiptInfo.fromJson(json['receipt']),
      tenant: Tenant.fromJson(json['tenantId']),
      property: Property.fromJson(json['propertyId']),
      room: Room.fromJson(json['roomId']),
      generatedBy: json['generatedBy'] != null
          ? GeneratedBy.fromJson(json['generatedBy'])
          : null,
      notes: json['notes'],
      timeline: (json['timeline'] as List)
          .map((e) => TimelineEntry.fromJson(e))
          .toList(),
    );
  }
}

class BillingPeriod {
  final int month;
  final int year;
  final DateTime startDate;
  final DateTime endDate;

  BillingPeriod({
    required this.month,
    required this.year,
    required this.startDate,
    required this.endDate,
  });

  factory BillingPeriod.fromJson(Map<String, dynamic> json) {
    return BillingPeriod(
      month: json['month'],
      year: json['year'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}

class Amounts {
  final num monthlyRent;
  final num maintenanceCharges;
  final num waterCharges;
  final num electricityCharges;
  final num otherCharges;
  final num subtotal;
  final num discount;
  final num lateFee;
  final num finalAmount;

  Amounts({
    required this.monthlyRent,
    required this.maintenanceCharges,
    required this.waterCharges,
    required this.electricityCharges,
    required this.otherCharges,
    required this.subtotal,
    required this.discount,
    required this.lateFee,
    required this.finalAmount,
  });

  factory Amounts.fromJson(Map<String, dynamic> json) {
    return Amounts(
      monthlyRent: json['monthlyRent'],
      maintenanceCharges: json['maintenanceCharges'],
      waterCharges: json['waterCharges'] ?? 0,
      electricityCharges: json['electricityCharges'] ?? 0,
      otherCharges: json['otherCharges'] ?? 0,
      subtotal: json['subtotal'],
      discount: json['discount'],
      lateFee: json['lateFee'] ?? 0,
      finalAmount: json['finalAmount'],
    );
  }
}

class PaymentDates {
  final DateTime dueDate;
  final DateTime gracePeriodEndDate;
  final DateTime generatedDate;

  PaymentDates({
    required this.dueDate,
    required this.gracePeriodEndDate,
    required this.generatedDate,
  });

  factory PaymentDates.fromJson(Map<String, dynamic> json) {
    return PaymentDates(
      dueDate: DateTime.parse(json['dueDate']),
      gracePeriodEndDate: DateTime.parse(json['gracePeriodEndDate']),
      generatedDate: DateTime.parse(json['generatedDate']),
    );
  }
}

class Tenant {
  final String name;
  final String phone;

  Tenant({required this.name, required this.phone});

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(name: json['name'], phone: json['phone']);
  }
}

class Property {
  final String title;

  Property({required this.title});

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(title: json['title']);
  }
}

class Room {
  final String roomNumber;

  Room({required this.roomNumber});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(roomNumber: json['roomNumber']);
  }
}

class TimelineEntry {
  final String action;
  final DateTime timestamp;
  final String notes;

  TimelineEntry({
    required this.action,
    required this.timestamp,
    required this.notes,
  });

  factory TimelineEntry.fromJson(Map<String, dynamic> json) {
    return TimelineEntry(
      action: json['action'],
      timestamp: DateTime.parse(json['timestamp']),
      notes: json['notes'],
    );
  }
}



class PaymentInfo {
  final num amountPaid;

  PaymentInfo({
    required this.amountPaid,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      amountPaid: json['amountPaid'] ?? 0,
    );
  }
}



class LateFeeCalculation {
  final bool enabled;
  final num ratePerDay;
  final int daysOverdue;
  final bool waived;

  LateFeeCalculation({
    required this.enabled,
    required this.ratePerDay,
    required this.daysOverdue,
    required this.waived,
  });

  factory LateFeeCalculation.fromJson(Map<String, dynamic> json) {
    return LateFeeCalculation(
      enabled: json['enabled'] ?? false,
      ratePerDay: json['ratePerDay'] ?? 0,
      daysOverdue: json['daysOverdue'] ?? 0,
      waived: json['waived'] ?? false,
    );
  }
}


class ReceiptInfo {
  final int downloadCount;
  final bool emailSent;

  ReceiptInfo({
    required this.downloadCount,
    required this.emailSent,
  });

  factory ReceiptInfo.fromJson(Map<String, dynamic> json) {
    return ReceiptInfo(
      downloadCount: json['downloadCount'] ?? 0,
      emailSent: json['emailSent'] ?? false,
    );
  }
}


class GeneratedBy {
  final String userId;
  final String role;
  final String name;

  GeneratedBy({
    required this.userId,
    required this.role,
    required this.name,
  });

  factory GeneratedBy.fromJson(Map<String, dynamic> json) {
    return GeneratedBy(
      userId: json['userId'],
      role: json['role'],
      name: json['name'],
    );
  }
}




class OverduePaymentsResponse {
  final bool success;
  final int count;
  final num totalOverdue;
  final List<RentPayment> data;

  OverduePaymentsResponse({
    required this.success,
    required this.count,
    required this.totalOverdue,
    required this.data,
  });

  factory OverduePaymentsResponse.fromJson(Map<String, dynamic> json) {
    return OverduePaymentsResponse(
      success: json['success'],
      count: json['count'],
      totalOverdue: json['totalOverdue'],
      data: (json['data'] as List)
          .map((e) => RentPayment.fromJson(e))
          .toList(),
    );
  }
}


class PaymentAnalyticsResponse {
  final bool success;
  final int year;
  final List<MonthlyAnalytics> monthlyData;
  final OverallStats overallStats;
  final num collectionRate;

  PaymentAnalyticsResponse({
    required this.success,
    required this.year,
    required this.monthlyData,
    required this.overallStats,
    required this.collectionRate,
  });

  factory PaymentAnalyticsResponse.fromJson(Map<String, dynamic> json) {
    return PaymentAnalyticsResponse(
      success: json['success'],
      year: json['year'],
      monthlyData: (json['monthlyData'] as List)
          .map((e) => MonthlyAnalytics.fromJson(e))
          .toList(),
      overallStats: OverallStats.fromJson(json['overallStats']),
      collectionRate: json['collectionRate'],
    );
  }
}

class MonthlyAnalytics {
  final int month; // _id = month number
  final num totalExpected;
  final num totalCollected;
  final int paidCount;
  final int overdueCount;
  final num totalLateFees;

  MonthlyAnalytics({
    required this.month,
    required this.totalExpected,
    required this.totalCollected,
    required this.paidCount,
    required this.overdueCount,
    required this.totalLateFees,
  });

  factory MonthlyAnalytics.fromJson(Map<String, dynamic> json) {
    return MonthlyAnalytics(
      month: json['_id'],
      totalExpected: json['totalExpected'],
      totalCollected: json['totalCollected'],
      paidCount: json['paidCount'],
      overdueCount: json['overdueCount'],
      totalLateFees: json['totalLateFees'],
    );
  }
}

class OverallStats {
  final int totalPayments;
  final num totalExpected;
  final num totalCollected;
  final num totalPending;
  final num totalLateFees;
  final num averageRent;

  OverallStats({
    required this.totalPayments,
    required this.totalExpected,
    required this.totalCollected,
    required this.totalPending,
    required this.totalLateFees,
    required this.averageRent,
  });

  factory OverallStats.fromJson(Map<String, dynamic> json) {
    return OverallStats(
      totalPayments: json['totalPayments'],
      totalExpected: json['totalExpected'],
      totalCollected: json['totalCollected'],
      totalPending: json['totalPending'],
      totalLateFees: json['totalLateFees'],
      averageRent: json['averageRent'],
    );
  }
}