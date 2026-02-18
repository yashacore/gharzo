import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gharzo_project/model/model/services_model.dart';
import 'package:http/http.dart' as http;

class ServicesApi {
  static const String _baseUrl = 'https://api.gharzoreality.com/api/services';

  static Future<ServicesResponse> fetchServices() async {
    print('📡 API CALL → $_baseUrl');

    final response = await http.get(Uri.parse(_baseUrl));

    print('📥 STATUS CODE → ${response.statusCode}');
    print('📥 RAW RESPONSE → ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print('✅ JSON PARSED SUCCESS');

      return ServicesResponse.fromJson(json);
    } else {
      throw Exception('Failed to load services: ${response.statusCode}');
    }
  }

  static const String _url =
      "https://api.gharzoreality.com/api/service-enquiries/create";

  static Future<Map<String, dynamic>> createEnquiry(
      ServiceEnquiryRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      debugPrint("📥 STATUS CODE → ${response.statusCode}");
      debugPrint("📥 RAW RESPONSE → ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      debugPrint("❌ API ERROR → $e");
      rethrow;
    }
  }
}
class ServiceEnquiryRequest {
  final String name;
  final String phone;
  final String email;
  final String subject;
  final String message;
  final String serviceId;
  final String preferredContactMethod;
  final String preferredTimeSlot;
  final Location location;

  ServiceEnquiryRequest({
    required this.name,
    required this.phone,
    required this.email,
    required this.subject,
    required this.message,
    required this.serviceId,
    required this.preferredContactMethod,
    required this.preferredTimeSlot,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "email": email,
      "subject": subject,
      "message": message,
      "serviceId": serviceId,
      "preferredContactMethod": preferredContactMethod,
      "preferredTimeSlot": preferredTimeSlot,
      "location": location.toJson(),
    };
  }
}

class Location {
  final String city;
  final String locality;
  final String pincode;
  final String address;

  Location({
    required this.city,
    required this.locality,
    required this.pincode,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      "city": city,
      "locality": locality,
      "pincode": pincode,
      "address": address,
    };
  }
}
class EnquiryResponse {
  final bool success;
  final String message;
  final EnquiryData data;

  EnquiryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EnquiryResponse.fromJson(Map<String, dynamic> json) {
    return EnquiryResponse(
      success: json['success'],
      message: json['message'],
      data: EnquiryData.fromJson(json['data']),
    );
  }
}
class EnquiryData {
  final Enquiry enquiry;
  final ServiceProviderContact serviceProvider;

  EnquiryData({
    required this.enquiry,
    required this.serviceProvider,
  });

  factory EnquiryData.fromJson(Map<String, dynamic> json) {
    return EnquiryData(
      enquiry: Enquiry.fromJson(json['enquiry']),
      serviceProvider:
      ServiceProviderContact.fromJson(json['serviceProvider']),
    );
  }
}
class Enquiry {
  final String enquiryNumber;
  final String subject;
  final String message;
  final String preferredContactMethod;
  final String preferredTimeSlot;
  final String status;

  Enquiry({
    required this.enquiryNumber,
    required this.subject,
    required this.message,
    required this.preferredContactMethod,
    required this.preferredTimeSlot,
    required this.status,
  });

  factory Enquiry.fromJson(Map<String, dynamic> json) {
    return Enquiry(
      enquiryNumber: json['enquiryNumber'],
      subject: json['subject'],
      message: json['message'],
      preferredContactMethod: json['preferredContactMethod'],
      preferredTimeSlot: json['preferredTimeSlot'],
      status: json['status'],
    );
  }
}
class ServiceProviderContact {
  final String companyName;
  final String phone;
  final String whatsappNumber;

  ServiceProviderContact({
    required this.companyName,
    required this.phone,
    required this.whatsappNumber,
  });

  factory ServiceProviderContact.fromJson(Map<String, dynamic> json) {
    return ServiceProviderContact(
      companyName: json['companyName'],
      phone: json['phone'],
      whatsappNumber: json['whatsappNumber'],
    );
  }
}
