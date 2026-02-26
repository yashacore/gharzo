import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/model/model/project_model.dart';
import 'package:gharzo_project/model/model/user_model/my_enquiry_model.dart';
import 'package:gharzo_project/model/model/user_model/project_details_model.dart';
import 'package:gharzo_project/model/model/user_model/project_enquiry_model.dart';
import 'package:gharzo_project/model/model/user_model/project_review_model.dart';
import 'package:gharzo_project/screens/projects/project_list_screen.dart';
import 'package:http/http.dart' as http;

class ProjectProvider extends ChangeNotifier {
  final String _url =
      "https://api.gharzoreality.com/api/projects";
  ProjectDetailModel? project;
  bool success = false;

  List<ProjectModel> projects = [];
  bool loading = false;
  String error = '';

  Future<void> fetchProjects() async {
    loading = true;
    error = '';
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['data'];

        projects = list
            .map((e) => ProjectModel.fromJson(e))
            .toList();
      } else {
        error = "Failed to load projects";
      }
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }

  Future<void> fetchProjectDetail(String identifier) async {
    loading = true;
    error = '';
    notifyListeners();

    try {
      final res = await http.get(
        Uri.parse("https://api.gharzoreality.com/api/projects/$identifier"),
      );

      if (res.statusCode == 200) {
        project =
            ProjectDetailModel.fromJson(json.decode(res.body));
      } else {
        error = "Failed to load project details";
      }
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }

  Future<void> createEnquiry(ProjectEnquiryRequest request,BuildContext context) async {
    loading = true;
    error = '';
    success = false;
    notifyListeners();

    try {
      final payload = request.toJson();

      // 🔍 DEBUG PRINTS
      debugPrint("🚀 API URL => /api/project-enquiries/create");
      debugPrint("📦 REQUEST BODY => ${jsonEncode(payload)}");
      final token = await PrefService.getToken();

      final response = await http.post(
        Uri.parse(
            'https://api.gharzoreality.com/api/project-enquiries/create'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",

        },
        body: jsonEncode(payload),
      );

      debugPrint("📡 STATUS CODE => ${response.statusCode}");
      debugPrint("📡 RESPONSE BODY => ${response.body}");

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        success = true;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ProjectListScreen(),
          ),
        );
        debugPrint("✅ ENQUIRY CREATED SUCCESSFULLY");
      } else {
        error = body['message'] ?? 'Something went wrong';
        debugPrint("❌ API ERROR => $error");
      }
    } catch (e, stack) {
      error = 'Network error. Please try again.';
      debugPrint("🔥 EXCEPTION => $e");
      debugPrint("🔥 STACKTRACE => $stack");
    }

    loading = false;
    notifyListeners();
  }

  Future<void> createReview(
      String projectId,
      ProjectReviewRequest request,
      ) async {
    loading = true;
    error = '';
    success = false;
    notifyListeners();

    try {
      final token = await PrefService.getToken();

      final response = await http.post(
        Uri.parse(
          'https://api.gharzoreality.com/api/projects/$projectId/review',
        ),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",

        },
        body: jsonEncode(request.toJson()),
      );

      debugPrint("📡 STATUS => ${response.statusCode}");
      debugPrint("📦 BODY => ${response.body}");

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        success = true;
      } else {
        error = body['message'] ?? 'Something went wrong';
      }
    } catch (e) {
      error = 'Network error. Please try again.';
    }

    loading = false;
    notifyListeners();
  }


  void reset() {
    error = '';
    success = false;
    notifyListeners();
  }

  List<MyEnquiryModel> myEnquiries = [];

  Future<void> fetchMyEnquiries() async {
    loading = true;
    error = '';
    notifyListeners();

    try {
      final token = await PrefService.getToken();

      final response = await http.get(
        Uri.parse(
          'https://api.gharzoreality.com/api/project-enquiries/my-enquiries',
        ),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",

          // 🔑 add token if required
          // 'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        myEnquiries = (body['data'] as List)
            .map((e) => MyEnquiryModel.fromJson(e))
            .toList();
      } else {
        error = body['message'] ?? 'Failed to load enquiries';
      }
    } catch (e) {
      error = 'Network error. Please try again.';
    }

    loading = false;
    notifyListeners();
  }
}