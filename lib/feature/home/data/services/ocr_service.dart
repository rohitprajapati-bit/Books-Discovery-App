import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../domain/services/ocr_service.dart';

class OCRServiceImpl implements OCRService {
  @override
  Future<List<Map<String, dynamic>>> recognizeTextDetailed(
    File imageFile,
  ) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      final List<Map<String, dynamic>> lines = [];
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          lines.add({
            'text': line.text,
            'height': line.boundingBox.height,
            'width': line.boundingBox.width,
            'top': line.boundingBox.top,
          });
        }
      }
      return lines;
    } finally {
      await textRecognizer.close();
    }
  }

  @override
  Future<String> recognizeText(File imageFile) async {
    final results = await recognizeTextDetailed(imageFile);
    return results.map((e) => e['text']).join('\n');
  }
}
