import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager/Data/Models/Network_Response.dart';
import 'package:task_manager/UI/Controllers/auth_controller.dart';
import 'package:task_manager/app.dart';

import '../../UI/Screen/SignInScreen.dart';

class NetworkCaller {
  static Future<NetworkResponse> getRequest(String url) async {
    try {
      Uri uri = Uri.parse(url);
       Map<String, String> headers = {
        'token': AuthController.accessToken.toString(),
      };

      debugPrint(url);
      final Response response = await get(uri,headers: headers);
      debugPrintRequest(url, null, headers);
      debugPrintResponse(url, response);
      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: decodeData);
      } else if (response.statusCode == 401) {
        moveToLogin();
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            errorMessage: 'Unauthenticated');
      } else {
        return NetworkResponse(
            isSuccess: false, statusCode: response.statusCode);
      }
    } catch (e) {
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static Future<NetworkResponse> postRequest(
      String url, Map<String, dynamic>? body) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'token': AuthController.accessToken.toString(),
      };

      debugPrintRequest(url, body, headers);
      final Response response =
          await post(uri, headers: headers, body: jsonEncode(body));
      debugPrintResponse(url, response);
      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: decodeData);
      } else if (response.statusCode == 401) {
        moveToLogin();
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            errorMessage: 'Unauthenticated');
      } else {
        return NetworkResponse(
            isSuccess: false, statusCode: response.statusCode);
      }
    } catch (e) {
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static void debugPrintRequest(
    String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
  ) {
    debugPrint('Request\nURL : $url\nBODY : $body\nHEADERS : $headers');
  }

  static void debugPrintResponse(String url, Response response) {
    debugPrint(
      'URL : $url\nRESPONSE CODE: ${response.statusCode}\nBODY : ${response.body}',
    );
  }

  static void moveToLogin() {
    AuthController.clearUserToken();
    Navigator.pushAndRemoveUntil(
        TaskManagerApp.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (_) => false);
  }
}
