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
  // Use https for better security and compatibility
  static const String baseUrl = "https://api.aswdc.in/Api/MST_AppVersions";
  static const String apiKey = "1234";

  /// Traditional feedback method using multipart/form-data
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

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["IsResult"] == 1;
      }

      print('Error in postAppFeedback: HTTP ${response.statusCode}');
      print('Response Body: ${response.body}');
      return false;

    } catch (e) {
      print('Exception in postAppFeedback: $e');
      return false;
    }
  }

  /// Feedback method using URL-encoded form data (often preferred by older .NET APIs)
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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["IsResult"] == 1;
      }
      
      print('Error in postAppFeedbackRegular: HTTP ${response.statusCode}');
      print('Response Body: ${response.body}');
      return false;
    } catch (e) {
      print('Exception in postAppFeedbackRegular: $e');
      return false;
    }
  }

  /// Gets details about a specific app by its name
  static Future<Map<String, dynamic>?> getAppDetails(String appName) async {
    try {
      final url = Uri.parse("$baseUrl/GetAppDetailByAppNameSystem/$appName");

      final response = await http.get(
        url,
        headers: {
          "API_KEY": apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["IsResult"] == 1 && data["ResultList"] != null && data["ResultList"].isNotEmpty) {
          return data["ResultList"][0];
        }
      } else {
        print('Error in getAppDetails: HTTP ${response.statusCode}');
      }
      return null;
    } catch (e) {
      print('Exception in getAppDetails: $e');
      return null;
    }
  }

  /// Enhanced feedback method with better error reporting and JSON support
  /// Switched to JSON POST as it's more standard and avoids common 500 errors with form-data
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

      // Some servers expect JSON, others expect Form Data. 
      // We will try standard POST (form-encoded) first, as it's the most common fallback.
      final response = await http.post(
        url,
        headers: {
          "API_KEY": apiKey,
          // Removed explicit Content-Type to let 'http' package set it correctly for the body type
        },
        body: {
          'AppName': appName,
          'VersionNo': versionNo,
          'Platform': platform,
          'PersonName': personName,
          'Mobile': mobile,
          'Email': email,
          'Message': message,
          'Remarks': remarks ?? '',
        },
      );

      print('API Response Code: ${response.statusCode}');
      print('API Response Body: ${response.body}');

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
            message: data["Message"] ?? "Server returned success but false result",
          );
        }
      } else if (response.statusCode == 500) {
        // If 500 error, try JSON approach as a fallback
        return await _postAppFeedbackJson(
          appName: appName,
          versionNo: versionNo,
          platform: platform,
          personName: personName,
          mobile: mobile,
          email: email,
          message: message,
          remarks: remarks,
        );
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

  /// Fallback method using JSON encoding
  static Future<FeedbackResult> _postAppFeedbackJson({
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
          "Content-Type": "application/json",
        },
        body: json.encode({
          'AppName': appName,
          'VersionNo': versionNo,
          'Platform': platform,
          'PersonName': personName,
          'Mobile': mobile,
          'Email': email,
          'Message': message,
          'Remarks': remarks ?? '',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return FeedbackResult(
          success: data["IsResult"] == 1,
          message: data["Message"] ?? (data["IsResult"] == 1 ? "Success" : "Failed"),
        );
      }
      
      return FeedbackResult(
        success: false,
        message: "JSON Fallback Error: ${response.statusCode}",
      );
    } catch (e) {
      return FeedbackResult(
        success: false,
        message: "JSON Fallback Exception: $e",
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

