import 'package:google_ml_kit/google_ml_kit.dart';

class FirebaseMLApi {
  static Future<String> recogniseText(String imgPath) async {
    final inputImage = InputImage.fromFilePath(imgPath);
    final textDetector = GoogleMlKit.vision.textDetector();
    try {
      final RecognisedText _reconizedText =
          await textDetector.processImage(inputImage);

      final text = await extractText(_reconizedText);
      return text.isEmpty ? 'No text found in the image' : text;
    } catch (error) {
      return error.toString();
    }
  }

  static extractText(RecognisedText visionText) {
    String text = '';

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          text = text + word.text + ' ';
        }
        text = text + '\n';
      }
    }

    return text;
  }
}
