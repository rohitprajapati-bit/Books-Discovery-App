import 'dart:io';

abstract class OCRService {
  Future<String> recognizeText(File imageFile);
  Future<List<Map<String, dynamic>>> recognizeTextDetailed(File imageFile);
}
