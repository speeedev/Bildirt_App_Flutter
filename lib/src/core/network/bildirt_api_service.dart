import 'package:bildirt/src/core/constants/bildirt_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BildirtApiService {
  static Future<bool> sendPushNotification(Map<String, dynamic> content) async {
    String restApiKey = REST_API_KEY;
    String apiKey = APP_API_KEY;

    Map<String, dynamic> data = {
      'apikey': apiKey,
      'process': 'newpush',
      'content': content,
    };

    String jsonData = jsonEncode(data);

    var response = await http.post(
      Uri.parse(API_URL),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Basic $restApiKey',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (responseBody.containsKey("error")) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  static Future getPushDetail(String id) async {
    String restApiKey = REST_API_KEY;
    String apiKey = APP_API_KEY;
    String pushId = id;
    Map<String, String> data = {
      'apikey': apiKey,
      'process': 'push_detail',
      'push_id': pushId,
    };

    String jsonData = jsonEncode(data);

    var response = await http.post(
      Uri.parse(API_URL),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Basic $restApiKey',
      },
      body: jsonData,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      return responseBody;
    } else {
      return {};
    }
  }
}
