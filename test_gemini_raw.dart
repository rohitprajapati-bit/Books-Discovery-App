import 'dart:convert';
import 'dart:io';

void main() async {
  const apiKey = 'AIzaSyC7Fj6Oc2bRVTlWF7iRi9_aImiTzTALFnI';
  const url =
      'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey';

  final client = HttpClient();
  try {
    print('Testing raw HTTP request to list models: $url');
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();

    final responseBody = await response.transform(utf8.decoder).join();
    print('Status Code: ${response.statusCode}');
    print('Response: $responseBody');
  } catch (e) {
    print('Error: $e');
  } finally {
    client.close();
  }
}
