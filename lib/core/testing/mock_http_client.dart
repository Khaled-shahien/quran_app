import 'package:http/http.dart' as http;
import 'dart:convert';

/// Mock HTTP Client for API Testing
///
/// Provides mock responses for testing API services
class MockHttpClient extends http.BaseClient {
  final Map<String, http.Response> _responses;
  final List<http.Request> _requests;

  MockHttpClient() : _responses = {}, _requests = [];

  /// Add a mock response for a specific URL and method
  void addResponse(String url, String method, http.Response response) {
    final key = '$method:$url';
    _responses[key] = response;
  }

  /// Add a successful JSON response
  void addJsonResponse(
    String url,
    String method,
    dynamic data, {
    int statusCode = 200,
  }) {
    final response = http.Response(
      jsonEncode(data),
      statusCode,
      headers: {'content-type': 'application/json'},
    );
    addResponse(url, method, response);
  }

  /// Add an error response
  void addErrorResponse(
    String url,
    String method,
    String message, {
    int statusCode = 500,
  }) {
    final response = http.Response(
      jsonEncode({'error': message, 'message': message}),
      statusCode,
      headers: {'content-type': 'application/json'},
    );
    addResponse(url, method, response);
  }

  /// Get all recorded requests
  List<http.Request> get requests => List.unmodifiable(_requests);

  /// Clear all recorded requests
  void clearRequests() {
    _requests.clear();
  }

  /// Verify that a request was made
  bool verifyRequest(String url, String method) {
    return _requests.any(
      (request) => request.url.toString() == url && request.method == method,
    );
  }

  /// Get request count
  int get requestCount => _requests.length;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    _requests.add(request as http.Request);

    final key = '${request.method}:${request.url}';
    final response = _responses[key];

    if (response != null) {
      return http.StreamedResponse(
        http.ByteStream.fromBytes(response.bodyBytes),
        response.statusCode,
        headers: response.headers,
        contentLength: response.contentLength,
      );
    }

    // Default response for unmocked requests
    return http.StreamedResponse(
      http.ByteStream.fromBytes(utf8.encode('{"error": "Not mocked"}')),
      404,
      headers: {'content-type': 'application/json'},
    );
  }
}
