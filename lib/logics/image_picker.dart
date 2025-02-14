import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class Picker {
  File? image;
  final TextRecognizer textRecognizer = GoogleMlKit.vision.textRecognizer();

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
  }

  Future<String> recognizeText() async {
    if (image == null) return '';

    final inputImage = InputImage.fromFile(image!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String resultText = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        resultText += line.text + ' ';
      }
    }

    return resultText.trim();
  }
}
