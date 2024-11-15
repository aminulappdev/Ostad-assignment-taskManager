// import 'dart:convert';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/UI/Controllers/auth_controller.dart';
import 'package:task_manager/UI/Controllers/update_profile_controller.dart';
import 'package:task_manager/UI/Widgets/Center_Circular_Progress_Indicator.dart';
import 'package:task_manager/UI/Widgets/SnackBarMessage.dart';

import 'package:task_manager/UI/Widgets/TM_AppBar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String updateProfileScreen = '/update-profile';

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

  final UpdateProfileController updateProfileController =
      Get.find<UpdateProfileController>();

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
                  GetBuilder<UpdateProfileController>(
                    builder: (controller) {
                      return Visibility(
                        visible: !controller.inprogress,
                        replacement: const CenterCircularProgressIndicator(),
                        child: ElevatedButton(
                          onPressed: updateProfileData,
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    },
                  )
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
    final bool result = await updateProfileController.updateProfileData(
        emailCtrl.text.trim(),
        firstNameCtrl.text.trim(),
        lastNameCtrl.text.trim(),
        phoneCtrl.text.trim(),
        passwordCtrl.text,
        selectedImage);

    if (result) {
      showSnackBarMessage(context, 'Profile updated');
      Get.back();
    } else {
      showSnackBarMessage(context, updateProfileController.errorMessage!, true);
    }
  }
}
