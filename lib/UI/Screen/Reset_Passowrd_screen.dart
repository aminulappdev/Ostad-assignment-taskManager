import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/Data/Models/Network_Response.dart';
import 'package:task_manager/Data/Services/Network_Caller.dart';
import 'package:task_manager/UI/Screen/SignInScreen.dart';
import 'package:task_manager/UI/Utils/app_colors.dart';
import 'package:task_manager/UI/Widgets/SnackBarMessage.dart';
import 'package:task_manager/UI/Widgets/screenBackground.dart';

import '../../Data/Utils/Urls.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({super.key, required this.email, this.otp});
  final String email;
  final otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  bool recoveryPassInprogress = false;

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
    recoveryPassInprogress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": widget.email,
      "OTP": widget.otp,
      "password": passwordCtrl.text
    };

    final NetworkResponse response =
        await NetworkCaller.postRequest(Urls.recoverResetPassword, requestBody);

    if (response.isSuccess) {
      showSnackBarMessage(context, 'Successfully password changed', true);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
          (_) => false);
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }

    recoveryPassInprogress = false;
    setState(() {});
  }

  void onTapSignIn() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (_) => false);
  }
}
