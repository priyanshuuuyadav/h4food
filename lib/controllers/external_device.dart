import 'package:image_picker/image_picker.dart';

class ExternalDevice {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return pickedFile.path;
    } else {
      return null;
    }
  }

  static Future<String?> imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      return pickedFile.path;
    } else {
      return null;
    }
  }
}
