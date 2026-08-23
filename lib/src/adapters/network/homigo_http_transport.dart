import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/network/homigo_network_client.dart';

class HomiGoHttpTransport implements HomiGoNetworkTransport {
  final http.Client _client;

  HomiGoHttpTransport({http.Client? client})
    : _client = client ?? http.Client();

  @override
  Future<HomiGoNetworkRawResponse> send(HomiGoNetworkRequest request) async {
    final body = request.body == null
        ? null
        : request.body is String
        ? request.body as String
        : jsonEncode(request.body);

    final response = switch (request.method) {
      HomiGoHttpMethod.get => await _client.get(
        request.uri,
        headers: request.headers,
      ),
      HomiGoHttpMethod.post => await _client.post(
        request.uri,
        headers: request.headers,
        body: body,
      ),
      HomiGoHttpMethod.put => await _client.put(
        request.uri,
        headers: request.headers,
        body: body,
      ),
      HomiGoHttpMethod.patch => await _client.patch(
        request.uri,
        headers: request.headers,
        body: body,
      ),
      HomiGoHttpMethod.delete => await _client.delete(
        request.uri,
        headers: request.headers,
        body: body,
      ),
    };

    return HomiGoNetworkRawResponse(
      statusCode: response.statusCode,
      body: response.body,
      headers: response.headers,
    );
  }

  void close() {
    _client.close();
  }
}
