import 'dart:convert';

import 'package:http/http.dart' as http;

import 'config.dart';
import 'exceptions.dart';

class ApiClient {
  final UPaymentsConfig config;
  final http.Client httpClient;

  ApiClient(this.config, [http.Client? httpClient])
      : httpClient = httpClient ?? http.Client();

  String get _authorizationHeader => 'ApiKey ${config.apiKey}';

  Map<String, String> get _defaultHeaders => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': _authorizationHeader,
      };

  Future<Map<String, dynamic>> getJson(String path,
      {Map<String, String>? queryParameters}) async {
    final uri = Uri.parse('${config.baseUrl}$path')
        .replace(queryParameters: queryParameters);
    final response = await httpClient.get(uri, headers: _defaultHeaders);
    return _parseResponse(response);
  }

  Future<Map<String, dynamic>> postJson(
      String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('${config.baseUrl}$path');
    final response = await httpClient.post(uri,
        headers: _defaultHeaders, body: jsonEncode(body));
    return _parseResponse(response);
  }

  Map<String, dynamic> _parseResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return <String, dynamic>{};
      }
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic>) {
        return data;
      }
      return {'data': data};
    }
    throw UPaymentsException.fromResponse(response.statusCode, response.body);
  }

  void close() {
    httpClient.close();
  }
}
