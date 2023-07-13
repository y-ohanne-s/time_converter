import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:time_converter/helper.dart';

const String key = "";
const String endpoint = "api.timezonedb.com";

class ApiRequest {
  static Future getTimeZoneList() async {
    final Map<String, String> queryParameters = {'key': key, 'format': 'json'};
    final Uri uri = Uri.http(endpoint, '/v2.1/list-time-zone', queryParameters);

    final http.Response res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Failed to load timezones');
    }

    Map<String, dynamic> data = jsonDecode(res.body);

    final formattedZones = HelperFuncitons.getFormattedZones(data['zones']);

    return formattedZones;
  }

  static Future convertTimeZone(String from, String to, int time) async {
    final Map<String, String> queryParameters = {
      'key': key,
      'format': 'json',
      'from': from,
      'to': to,
      'time': time.toString(),
    };
    final Uri uri = Uri.http(endpoint, '/v2.1/convert-time-zone', queryParameters);

    final http.Response res = await http.get(uri);
    Map<String, dynamic> data = jsonDecode(res.body);

    final formattedTimeData = HelperFuncitons.getFormattedConvertedTimeData(data);

    return formattedTimeData;
  }
}
