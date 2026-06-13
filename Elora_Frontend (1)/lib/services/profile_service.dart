import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static Map<String, dynamic> _mockProfile = {
    'fullName': 'Guest User',
    'email': 'guest@example.com',
    'imageUrl': null,
  };

  Future<Map<String, dynamic>> getProfile() async {
    // Just return the mocked local profile for now to ensure no crashes
    return _mockProfile;
  }

  Future<String> uploadProfileImage(String uid, XFile image) async {
    // In a real app without Firebase, this would upload to an S3 bucket or Node backend.
    // For now, we return a fake URL or empty to prevent crashes.
    return '';
  }

  Future<void> updateProfile({
    required String fullName,
    String? imageUrl,
  }) async {
    _mockProfile['fullName'] = fullName;
    if (imageUrl != null) {
      _mockProfile['imageUrl'] = imageUrl;
    }
  }

  Future<void> updateEmail(String newEmail) async {
    _mockProfile['email'] = newEmail;
  }

  Future<void> reAuthenticate(String password) async {
    // Mocked validation
  }
}
