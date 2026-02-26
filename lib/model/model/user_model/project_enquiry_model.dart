class ProjectEnquiryRequest {
  final String projectId;

  // enquiryFrom
  final String name;
  final String phone;
  final String? email;

  // interestedIn
  final String? configurationType;
  final int? budgetMin;
  final int? budgetMax;
  final String? purposeOfBuying;

  // enquiry
  final String? message;
  final String preferredContactMethod;
  final String preferredTimeSlot;

  // site visit
  final bool siteVisitRequested;
  final DateTime? preferredDate;
  final String? preferredTime;
  final int? numberOfPeople;

  ProjectEnquiryRequest({
    required this.projectId,
    required this.name,
    required this.phone,
    this.email,
    this.configurationType,
    this.budgetMin,
    this.budgetMax,
    this.purposeOfBuying,
    this.message,
    this.preferredContactMethod = 'WhatsApp',
    this.preferredTimeSlot = 'Anytime',
    this.siteVisitRequested = false,
    this.preferredDate,
    this.preferredTime,
    this.numberOfPeople,
  });

  Map<String, dynamic> toJson() {
    return {
      "projectId": projectId,

      // 🔥 FLAT FIELDS (FOR CURRENT BACKEND)
      "name": name,
      "phone": phone,
      if (email != null) "email": email,

      // 🔥 NESTED FIELDS (FOR SCHEMA / FUTURE)
      "enquiryFrom": {
        "name": name,
        "phone": phone,
        if (email != null) "email": email,
      },

      // ===== interestedIn =====
      if (configurationType != null ||
          budgetMin != null ||
          budgetMax != null ||
          purposeOfBuying != null)
        "interestedIn": {
          if (configurationType != null)
            "configurationType": configurationType,
          if (budgetMin != null || budgetMax != null)
            "budgetRange": {
              if (budgetMin != null) "min": budgetMin,
              if (budgetMax != null) "max": budgetMax,
            },
          if (purposeOfBuying != null)
            "purposeOfBuying": purposeOfBuying,
        },

      if (message != null) "message": message,

      "preferredContactMethod": preferredContactMethod,
      "preferredTimeSlot": preferredTimeSlot,

      "siteVisitRequested": siteVisitRequested,

      if (siteVisitRequested)
        "siteVisitDetails": {
          if (preferredDate != null)
            "preferredDate": preferredDate!.toIso8601String(),
          if (preferredTime != null)
            "preferredTime": preferredTime,
          if (numberOfPeople != null)
            "numberOfPeople": numberOfPeople,
        },
    };
  }}