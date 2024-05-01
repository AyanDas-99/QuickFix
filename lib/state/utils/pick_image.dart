import 'package:image_picker/image_picker.dart';

class PickImage {
  static Future<List<String>> pickImages(int? limit) async {
    final fileList = await ImagePicker().pickMultiImage(limit: limit);
    return fileList.map((e) => e.path).toList();
  }

  static Future<String?> pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    return file?.path;
  }
}
