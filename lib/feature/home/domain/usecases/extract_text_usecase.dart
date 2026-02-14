import 'dart:io';
import '../services/ocr_service.dart';

class ExtractTextUseCase {
  final OCRService ocrService;

  ExtractTextUseCase(this.ocrService);

  Future<String> execute(File imageFile) async {
    return await ocrService.recognizeText(imageFile);
  }

  Future<List<Map<String, dynamic>>> executeDetailed(File imageFile) async {
    return await ocrService.recognizeTextDetailed(imageFile);
  }
}
