// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class ApiService {
//   static const String baseUrl = "http://api.aswdc.in/Api/MST_AppVersions";
//   static const String apiKey = "1234";
//
//   static Future<bool> postAppFeedback({
//     required String appName,
//     required String versionNo,
//     required String platform,
//     required String personName,
//     required String mobile,
//     required String email,
//     required String message,
//     String? remarks,
//   }) async {
//     final url = Uri.parse("$baseUrl/PostAppFeedback/AppPostFeedback");
//
//     final response = await http.post(
//       url,
//       headers: {"API_KEY": apiKey},
//       body: {
//         "AppName": appName,
//         "VersionNo": versionNo,
//         "Platform": platform,
//         "PersonName": personName,
//         "Mobile": mobile,
//         "Email": email,
//         "Message": message,
//         "Remarks": remarks ?? "",
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return data["IsResult"] == 1;
//     }
//     return false;
//   }
//
//   static Future<Map<String, dynamic>?> getAppDetails(String appName) async {
//     final url = Uri.parse("$baseUrl/GetAppDetailByAppNameSystem/$appName");
//
//     final response = await http.get(url, headers: {"API_KEY": apiKey});
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data["IsResult"] == 1) {
//         return data["ResultList"][0];
//       }
//     }
//     return null;
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://api.aswdc.in/Api/MST_AppVersions";
  static const String apiKey = "1234";

  static Future<bool> postAppFeedback({
    required String appName,
    required String versionNo,
    required String platform,
    required String personName,
    required String mobile,
    required String email,
    required String message,
    String? remarks,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/PostAppFeedback/AppPostFeedback");


      final request = http.MultipartRequest('POST', url);
      request.headers['API_KEY'] = apiKey;

      request.fields.addAll({
        'AppName': appName,
        'VersionNo': versionNo,
        'Platform': platform,
        'PersonName': personName,
        'Mobile': mobile,
        'Email': email,
        'Message': message,
        'Remarks': remarks ?? '',
      });

      print('Sending feedback request...');
      print('URL: $url');
      print('Fields: ${request.fields}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["IsResult"] == 1;
      }

      print('Error: HTTP ${response.statusCode}');
      return false;

    } catch (e) {
      print('Exception in postAppFeedback: $e');
      return false;
    }
  }

  static Future<bool> postAppFeedbackRegular({
    required String appName,
    required String versionNo,
    required String platform,
    required String personName,
    required String mobile,
    required String email,
    required String message,
    String? remarks,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/PostAppFeedback/AppPostFeedback");

      final response = await http.post(
        url,
        headers: {
          "API_KEY": apiKey,
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "AppName": appName,
          "VersionNo": versionNo,
          "Platform": platform,
          "PersonName": personName,
          "Mobile": mobile,
          "Email": email,
          "Message": message,
          "Remarks": remarks ?? "",
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["IsResult"] == 1;
      }
      return false;
    } catch (e) {
      print('Exception in postAppFeedbackRegular: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getAppDetails(String appName) async {
    try {
      final url = Uri.parse("$baseUrl/GetAppDetailByAppNameSystem/$appName");

      print('Getting app details for: $appName');
      print('URL: $url');

      final response = await http.get(
        url,
        headers: {
          "API_KEY": apiKey,
          "Content-Type": "application/json",
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["IsResult"] == 1 && data["ResultList"] != null && data["ResultList"].isNotEmpty) {
          return data["ResultList"][0];
        }
      }
      return null;
    } catch (e) {
      print('Exception in getAppDetails: $e');
      return null;
    }
  }

  static Future<FeedbackResult> postAppFeedbackEnhanced({
    required String appName,
    required String versionNo,
    required String platform,
    required String personName,
    required String mobile,
    required String email,
    required String message,
    String? remarks,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/PostAppFeedback/AppPostFeedback");

      final request = http.MultipartRequest('POST', url);
      request.headers['API_KEY'] = apiKey;

      request.fields.addAll({
        'AppName': appName,
        'VersionNo': versionNo,
        'Platform': platform,
        'PersonName': personName,
        'Mobile': mobile,
        'Email': email,
        'Message': message,
        'Remarks': remarks ?? '',
      });

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["IsResult"] == 1) {
          return FeedbackResult(
            success: true,
            message: data["Message"] ?? "Feedback submitted successfully!",
          );
        } else {
          return FeedbackResult(
            success: false,
            message: data["Message"] ?? "Failed to submit feedback",
          );
        }
      } else {
        return FeedbackResult(
          success: false,
          message: "Server error: ${response.statusCode}",
        );
      }
    } catch (e) {
      return FeedbackResult(
        success: false,
        message: "Network error: $e",
      );
    }
  }

  static bool isValidMobile(String mobile) {
    return RegExp(r'^\d{10}$').hasMatch(mobile);
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }
}

class FeedbackResult {
  final bool success;
  final String message;

  FeedbackResult({required this.success, required this.message});
}