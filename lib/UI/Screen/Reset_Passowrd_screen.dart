import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/UI/Controllers/reset_password_controller.dart';
import 'package:task_manager/UI/Controllers/varification_controller.dart';
import 'package:task_manager/UI/Screen/SignInScreen.dart';
import 'package:task_manager/UI/Utils/app_colors.dart';
import 'package:task_manager/UI/Widgets/SnackBarMessage.dart';
import 'package:task_manager/UI/Widgets/screenBackground.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({super.key,});
  
  static const String resetPasswordScreen = '/reset-password';
  
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final ResetPasswordController resetPasswordController =
      Get.find<ResetPasswordController>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ScreenBackground(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 80,
              ),
              Text(
                "Set Password",
                style: textTheme.displaySmall
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                "Minimum number of password should be 8 letters",
                style: textTheme.titleMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(
                height: 20,
              ),
              buildResetPasswordForm(),
              const SizedBox(
                height: 30,
              ),
              buildHaveAnAccountSection()
            ],
          ),
        ),
      )),
    );
  }

  Widget buildHaveAnAccountSection() {
    return Center(
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.5),
              text: "Have an account? ",
              children: [
                TextSpan(
                  style: const TextStyle(color: AppColors.themeColor),
                  text: 'Sign In',
                  recognizer: TapGestureRecognizer()..onTap = onTapSignIn,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildResetPasswordForm() {
    return Form(
      key: _globalKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Password';
              }
              return null;
            },
            controller: passwordCtrl,
            decoration: const InputDecoration(
              hintText: "Password",
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: confirmPasswordCtrl,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Password';
              } else if (value != passwordCtrl.text) {
                return 'Password not match';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Confirm Password",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: onTapNextButton,
            child: const Icon(Icons.arrow_circle_right_outlined),
          ),
        ],
      ),
    );
  }

  void onTapNextButton() {
    if (_globalKey.currentState!.validate()) {
      changePassword();
    } else {
      print('Wrong');
    }
  }

  Future<void> changePassword() async {
    final email = Get.find<VarificationController>().userEmail;
    final otp = Get.find<VarificationController>().userOtp;
    print('Controller email and otp : $email $otp');
    final bool result = await resetPasswordController.changePassword(
        email!,otp!, passwordCtrl.text);

    if (result) {
      showSnackBarMessage(context, 'Successfully password changed', true);
      Get.offAllNamed(SignInScreen.signInScreen);
    } else {
      showSnackBarMessage(context, resetPasswordController.errorMessage!, true);
    }
  }

  void onTapSignIn() {
     Get.offAllNamed(SignInScreen.signInScreen);
  }
}
