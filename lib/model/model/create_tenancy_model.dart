class CreateTenancyRequest {
  final String propertyId;
  final String roomId;
  final int bedNumber;
  final TenantInfo tenantInfo;
  final Agreement agreement;
  final Financials financials;

  CreateTenancyRequest({
    required this.propertyId,
    required this.roomId,
    required this.bedNumber,
    required this.tenantInfo,
    required this.agreement,
    required this.financials,
  });

  Map<String, dynamic> toJson() {
    return {
      "propertyId": propertyId,
      "roomId": roomId,
      "bedNumber": bedNumber,
      "tenantInfo": tenantInfo.toJson(),
      "agreement": agreement.toJson(),
      "financials": financials.toJson(),
    };
  }
}

class TenantInfo {
  final String name;
  final String phone;
  final EmergencyContact emergencyContact;
  final IdProof idProof;
  final PoliceVerification policeVerification;
  final EmploymentDetails employmentDetails;

  TenantInfo({
    required this.name,
    required this.phone,
    required this.emergencyContact,
    required this.idProof,
    required this.policeVerification,
    required this.employmentDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "emergencyContact": emergencyContact.toJson(),
      "idProof": idProof.toJson(),
      "policeVerification": policeVerification.toJson(),
      "employmentDetails": employmentDetails.toJson(),
    };
  }
}

class EmergencyContact {
  final String name;
  final String phone;
  final String relation;

  EmergencyContact({
    required this.name,
    required this.phone,
    required this.relation,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
    "relation": relation,
  };
}

class IdProof {
  final String type;
  final String number;

  IdProof({required this.type, required this.number});

  Map<String, dynamic> toJson() => {"type": type, "number": number};
}

class PoliceVerification {
  final bool done;

  PoliceVerification({required this.done});

  Map<String, dynamic> toJson() => {"done": done};
}

class EmploymentDetails {
  final String type;

  EmploymentDetails({required this.type});

  Map<String, dynamic> toJson() => {"type": type};
}

class Agreement {
  final String startDate;
  final String endDate;
  final int durationMonths;
  final bool renewalOption;
  final bool autoRenew;

  Agreement({
    required this.startDate,
    required this.endDate,
    required this.durationMonths,
    required this.renewalOption,
    required this.autoRenew,
  });

  Map<String, dynamic> toJson() => {
    "startDate": startDate,
    "endDate": endDate,
    "durationMonths": durationMonths,
    "renewalOption": renewalOption,
    "autoRenew": autoRenew,
  };
}

class Financials {
  final int monthlyRent;
  final int securityDeposit;
  final bool securityDepositPaid;
  final int maintenanceCharges;
  final int rentDueDay;
  final int lateFeePerDay;
  final int gracePeriodDays;

  Financials({
    required this.monthlyRent,
    required this.securityDeposit,
    required this.securityDepositPaid,
    required this.maintenanceCharges,
    required this.rentDueDay,
    required this.lateFeePerDay,
    required this.gracePeriodDays,
  });

  Map<String, dynamic> toJson() => {
    "monthlyRent": monthlyRent,
    "securityDeposit": securityDeposit,
    "securityDepositPaid": securityDepositPaid,
    "maintenanceCharges": maintenanceCharges,
    "rentDueDay": rentDueDay,
    "lateFeePerDay": lateFeePerDay,
    "gracePeriodDays": gracePeriodDays,
  };
}
