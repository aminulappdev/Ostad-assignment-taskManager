import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/UI/Controllers/auth_controller.dart';
import 'package:task_manager/UI/Controllers/update_profile_controller.dart';
import 'package:task_manager/UI/Screen/Profile_Screen.dart';
import 'package:task_manager/UI/Screen/SignInScreen.dart';
import 'package:task_manager/UI/Utils/app_colors.dart';

// ignore: must_be_immutable
class TMappBar extends StatefulWidget implements PreferredSizeWidget {
  TMappBar({
    super.key,
    this.isProfileScreenOpen = false,
  });
  final bool isProfileScreenOpen;

  @override
  State<TMappBar> createState() => _TMappBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TMappBarState extends State<TMappBar> {
  String? userName;

  @override
  // void initState() {
  //   super.initState();

  //   var updateName = Get.find<UpdateProfileController>().fullName ?? '';
  //   print('Update name : $updateName');
  //   if (updateName == '') {
  //     print('Null Update name : $updateName');
  //     userName = updateName;
  //   }
  // }

  String decode_image() {
    String encodeImage = AuthController.userData!.photo ?? '';
    Uint8List decode_mage = base64Decode(encodeImage);
    return decode_mage.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isProfileScreenOpen) {
          return;
        }
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
            ));
      },
      child: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 18,
            ),
            const SizedBox(
              width: 15,
            ),
            GetBuilder<UpdateProfileController>(
              builder: (controller) {
                return Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Get.find<UpdateProfileController>().fullName == null) ...{
                    Text(
                      AuthController.userData?.fullname ?? '',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  } else ...{
                    Text(
                      Get.find<UpdateProfileController>().fullName ?? '',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  },
                  Text(
                    AuthController.userData?.email ?? '',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ],
              ));
              },
            ),
            IconButton(
              onPressed: () async {
                await AuthController.clearUserToken();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                    (_) => false);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}
