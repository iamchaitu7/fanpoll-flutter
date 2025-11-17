// ignore_for_file: file_names, avoid_print, depend_on_referenced_packages, non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'localStorageService.dart';

class ApiService {
  //static final String baseUrl = 'https://fpw.zbit.ltd/api/';
  static final String baseUrl = 'https://api.fanpollworld.com/api/';

  Future<dynamic> getProfile(String token) async {
    final uri = Uri.parse('${baseUrl}profile');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print("Profile Status: ${response.statusCode}");
    print("Profile Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<dynamic> getFollowers() async {
    final uri = Uri.parse('${baseUrl}user/followers/');
    final token = await LocalStorageService.getString('token');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print("Profile Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<dynamic> getFollowing() async {
    final token = await LocalStorageService.getString('token');
    final uri = Uri.parse('${baseUrl}user/following/');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print("Profile Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<dynamic> postLoginFormData({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('${baseUrl}auth/login_with_email');

    var request = http.MultipartRequest('POST', uri)
      ..fields['email'] = email
      ..fields['password'] = password;

    request.headers.addAll({
      'Cookie': 'fpw_zbt=your_cookie_value',
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("Login Status: ${response.statusCode}");
    print("Login Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Login failed');
    }
  }

  Future<dynamic> postRegisterFormData({
    required String full_name,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('${baseUrl}auth/create_account');

    var request = http.MultipartRequest('POST', uri)
      ..fields['full_name'] = full_name
      ..fields['email'] = email
      ..fields['password'] = password;

    request.headers.addAll({
      'Cookie': 'fpw_zbt=your_cookie_value',
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("Register Status: ${response.statusCode}");
    print("Reguster Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Login failed');
    }
  }

  Future<Map<String, dynamic>> postGoogleFormData({
    required String email,
    required String auth_method,
    required String oauth_id,
    required String full_name,
  }) async {
    final uri = Uri.parse('${baseUrl}auth/login_with_oauth');

    var request = http.MultipartRequest('POST', uri)
      ..fields['full_name'] = full_name
      ..fields['email'] = email
      ..fields['auth_method'] = auth_method
      ..fields['oauth_id'] = oauth_id;

    request.headers.addAll({
      'Cookie': 'fpw_zbt=your_cookie_value',
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print("Register Status: ${response.statusCode}");
    print("Reguster Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Login failed');
    }
  }

  Future<dynamic> postSendOTP({
    required String email,
  }) async {
    final uri = Uri.parse('${baseUrl}auth/send_forgot_otp');

    var request = http.MultipartRequest('POST', uri)..fields['email'] = email;

    request.headers.addAll({
      'Cookie': 'fpw_zbt=your_cookie_value',
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("OTP SEND RESPONSE : ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Error ');
    }
  }

  Future<dynamic> postChnagePasswordFormData({
    required String email,
    required String otp,
    required String new_password,
  }) async {
    final uri = Uri.parse('${baseUrl}auth/set_new_password');

    var request = http.MultipartRequest('POST', uri)
      ..fields['email'] = email
      ..fields['otp'] = otp
      ..fields['new_password'] = new_password;

    request.headers.addAll({
      'Cookie': 'fpw_zbt=your_cookie_value',
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("New Password  Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'getting error');
    }
  }

  Future<dynamic> postCreatePoll({
    required String title,
    required String description,
    required String url,
    required String hashtags,
    required List<String> options,
    required int expiresInDays,
    File? imageFile,
    Uint8List? webImageBytes,
  }) async {
    final token = await LocalStorageService.getString('token');
    final uri = Uri.parse('${ApiService.baseUrl}poll/create');
    print("OPTIONS :::${options}");
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'Authorization': token ?? "",
      })
      ..fields['title'] = title
      ..fields['description'] = description
      ..fields['url'] = url
      ..fields['hashtags'] = hashtags
      ..fields['expires_in_days'] = expiresInDays.toString();

    // Add options[]
    for (var i = 0; i < options.length; i++) {
      request.fields['options[$i]'] = options[i];
    }

    // Add image if present
    if (kIsWeb) {
      if (webImageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            webImageBytes,
            filename: 'image.jpg',
          ),
        );
      }
    } else {
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
          ),
        );
      }
    }

    print("\n========= POLL UPLOAD DATA =========");
    print("Authorization Token: ${token}");
    request.fields.forEach((key, value) {
      print("Field: $key => $value");
    });
    for (var file in request.files) {
      print("File: ${file.field} => ${file.filename}");
    }
    print("====================================\n");

    var streamedResponse = await request.send();
    print("streamedResponse :: ${streamedResponse.request}");
    var response = await http.Response.fromStream(streamedResponse);

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Poll creation failed');
    }
  }

  Future<dynamic> postVoteFormData({required poll_id, required String option_id}) async {
    final uri = Uri.parse('${baseUrl}poll/vote');
    final token = await LocalStorageService.getString('token');
    var request = http.MultipartRequest('POST', uri)
      ..fields['poll_id'] = poll_id
      ..fields['option_id'] = option_id;

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Cookie': 'fpw_zbt=your_cookie_value',
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print("Vote :: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'You hav voted on this poll ');
    }
  }

  Future<dynamic> postLikeFormData({required poll_id}) async {
    final uri = Uri.parse('${baseUrl}poll/toggle_like');
    final token = await LocalStorageService.getString('token');
    var request = http.MultipartRequest('POST', uri)..fields['poll_id'] = poll_id;

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Cookie': 'fpw_zbt=your_cookie_value',
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print("Vote :: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'You hav voted on this poll ');
    }
  }

  Future<dynamic> postUndoVoteFormData({
    required String poll_id,
  }) async {
    final uri = Uri.parse('${baseUrl}poll/undo_vote');
    final token = await LocalStorageService.getString('token');
    var request = http.MultipartRequest('POST', uri)..fields['poll_id'] = poll_id;

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Cookie': 'fpw_zbt=your_cookie_value',
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print("Vote :: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'You hav voted on this poll ');
    }
  }

  Future<dynamic> postDeletePollFormData({
    required String poll_id,
  }) async {
    final token = await LocalStorageService.getString('token');
    final uri = Uri.parse('${baseUrl}poll/delete');

    var request = http.MultipartRequest('POST', uri)..fields['poll_id'] = poll_id;

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Cookie': 'fpw_zbt=your_cookie_value',
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("Delete Poll Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Delete Poll failed');
    }
  }

  Future<dynamic> postFollowFormData({
    required String userId,
  }) async {
    final token = await LocalStorageService.getString('token');
    final uri = Uri.parse('${baseUrl}user/follow_user');

    var request = http.MultipartRequest('POST', uri)..fields['user_id'] = userId;

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Cookie': 'fpw_zbt=your_cookie_value',
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("User Follow Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Delete Poll failed');
    }
  }

  Future<dynamic> postUnFollowFormData({
    required String userId,
  }) async {
    final token = await LocalStorageService.getString('token');
    final uri = Uri.parse('${baseUrl}user/unfollow_user');

    var request = http.MultipartRequest('POST', uri)..fields['user_id'] = userId;

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Cookie': 'fpw_zbt=your_cookie_value',
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("User Follow Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Delete Poll failed');
    }
  }

  Future<Map<String, dynamic>> getUserPolls(String token, String userId, int page) async {
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}poll/user_polls/$userId?page=$page'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return jsonDecode(response.body);
  }

  /// PUT/UPDATE Request
  Future<dynamic> putRequest(String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('PUT failed: ${response.statusCode}');
    }
  }
}

// headers: {
//   'Content-Type': 'application/json',
//   'Authorization': 'Bearer YOUR_TOKEN',
// }
