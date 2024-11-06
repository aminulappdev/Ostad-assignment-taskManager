// import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/Data/Models/Network_Response.dart';
import 'package:task_manager/Data/Models/UserModel.dart';
import 'package:task_manager/Data/Services/Network_Caller.dart';
import 'package:task_manager/Data/Utils/Urls.dart';
import 'package:task_manager/UI/Controllers/auth_controller.dart';
import 'package:task_manager/UI/Widgets/Center_Circular_Progress_Indicator.dart';
import 'package:task_manager/UI/Widgets/SnackBarMessage.dart';

import 'package:task_manager/UI/Widgets/TM_AppBar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool updateProfileInprogress = false;

  XFile? selectedImage;

  @override
  void initState() {
    super.initState();
    setUserdata();
  }

  void setUserdata() {
    emailCtrl.text = AuthController.userData!.email ?? '';
    firstNameCtrl.text = AuthController.userData!.firstName ?? '';
    lastNameCtrl.text = AuthController.userData!.lastName ?? '';
    phoneCtrl.text = AuthController.userData!.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return PopScope(
      child: Scaffold(
        appBar: TMappBar(
          isProfileScreenOpen: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Update Profile",
                    style: textTheme.displaySmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: pickedImage,
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                            ),
                            child: const Center(
                              child: Text(
                                'Photos',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(getSelectedPhotoTitle())
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter email';
                      }
                      return null;
                    },
                    enabled: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailCtrl,
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter firstname';
                      }
                      return null;
                    },
                    controller: firstNameCtrl,
                    decoration: const InputDecoration(
                      hintText: "First name",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter lastname';
                      }
                      return null;
                    },
                    controller: lastNameCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Last name",
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter phone number';
                      }
                      return null;
                    },
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: "Phone",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passwordCtrl,
                    decoration: const InputDecoration(
                      hintText: "password",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: !updateProfileInprogress,
                    replacement: const CenterCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: updateProfileData,
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateProfileBTN() {
    if (_formKey.currentState!.validate()) {
      updateProfileData();
    }
  }

  Future<void> pickedImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      selectedImage = pickedImage;
      setState(() {});
    }
  }

  String getSelectedPhotoTitle() {
    if (selectedImage != null) {
      return selectedImage!.name;
    }
    return 'Selected photo';
  }

  Future<void> updateProfileData() async {
    updateProfileInprogress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": emailCtrl.text.trim(),
      "firstName": firstNameCtrl.text.trim(),
      "lastName": lastNameCtrl.text.trim(),
      "mobile": phoneCtrl.text.trim()
    };

    if (passwordCtrl.text.isNotEmpty) {
      requestBody['password'] = passwordCtrl.text;
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

    // if (selectedImage != null) {
    //   // List<int> imageBytes = await selectedImage!.readAsBytes();
    //   // String convertImage = base64Encode(imageBytes);
    //   requestBody['photo'] = 'convertImage';
    // }

    final NetworkResponse response =
        await NetworkCaller.postRequest(Urls.profileUpdate, requestBody);
    updateProfileInprogress = false;
    setState(() {});

    if (response.isSuccess) {
  
      UserModel userModel = UserModel.fromJson(requestBody);
      AuthController.saveUserData(userModel);
      showSnackBarMessage(context, 'Profile updated');
      //  String fullnameUpdate = '${firstNameCtrl.text} ${lastNameCtrl.text}';
      String firstNameUpdate = '${firstNameCtrl.text}';
      AuthController.userData!.firstName = firstNameUpdate;

      Navigator.pop(
        context,
      );

      setState(() {});
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }
}
