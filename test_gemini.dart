import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  final model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: 'AIzaSyC7Fj6Oc2bRVTlWF7iRi9_aImiTzTALFnI',
  );

  try {
    print('Testing with gemini-pro...');
    final response = await model.generateContent([
      Content.text('Say "Hello World"'),
    ]);
    print('✅ Success: ${response.text}');
  } catch (e) {
    print('❌ Error: $e');
  }
}
