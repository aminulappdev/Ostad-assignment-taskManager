
import 'package:flutter/material.dart';
import 'package:task_manager/UI/Controllers/auth_controller.dart';
import 'package:task_manager/UI/Screen/Profile_Screen.dart';
import 'package:task_manager/UI/Screen/SignInScreen.dart';
import 'package:task_manager/UI/Utils/app_colors.dart';

// ignore: must_be_immutable
class TMappBar extends StatefulWidget implements PreferredSizeWidget {
  TMappBar({super.key, this.isProfileScreenOpen = false, this.name});
  final bool isProfileScreenOpen;
  String? name;

  @override
  State<TMappBar> createState() => _TMappBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TMappBarState extends State<TMappBar> {
  String userName = AuthController.userData!.fullname ?? '';
 

  @override
  void initState() {
    super.initState();
    if (widget.name != null) {
      userName = widget.name!;
    }
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
             CircleAvatar(
              radius: 18,
              //  child: Image(image: NetworkImage(imageBytes.toString()),fit: BoxFit.fill,),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName ?? '',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                Text(
                  AuthController.userData?.email ?? '',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
              ],
            )),
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
