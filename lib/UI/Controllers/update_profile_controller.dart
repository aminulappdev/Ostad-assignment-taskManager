import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:task_manager/Data/Models/Network_Response.dart';
import 'package:task_manager/Data/Models/UserModel.dart';
import 'package:task_manager/Data/Services/Network_Caller.dart';
import 'package:task_manager/Data/Utils/Urls.dart';
import 'package:task_manager/UI/Controllers/auth_controller.dart';

class UpdateProfileController extends GetxController {
  bool isSuccess = false;
  bool _inProgress = false;
  bool get inprogress => _inProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  String? fullName;
  

  Future<bool> updateProfileData(
      String email,
      String firstName,
      String lastName,
      String mobile,
      String password,
      XFile? selectedImage) async {
    _inProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile
    };

    if (password.isNotEmpty) {
      requestBody['password'] = password;
    }

    if (selectedImage != null) {
      List<int> imageBytes = await selectedImage!.readAsBytes();

      // Convert List<int> to Uint8List
      Uint8List uint8ImageBytes = Uint8List.fromList(imageBytes);

      // Compress the image
      List<int> compressedImageBytes =
          await FlutterImageCompress.compressWithList(
        uint8ImageBytes,
        quality: 50,
      );

      // Encode the compressed image to base64
      String convertedImage = base64Encode(compressedImageBytes);
      print('Converted Image: $convertedImage');

      requestBody['photo'] = convertedImage;
    }

    final NetworkResponse response =
        await NetworkCaller.postRequest(Urls.profileUpdate, requestBody);

    if (response.isSuccess) {
      UserModel userModel = UserModel.fromJson(requestBody);
      AuthController.saveUserData(userModel);

      //  String fullnameUpdate = '${firstNameCtrl.text} ${lastNameCtrl.text}';
      String firstNameUpdate = firstName;
      AuthController.userData!.firstName = firstNameUpdate;
      fullName = '$firstName $lastName';
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = true;
    update();

    return isSuccess;
  }
}
