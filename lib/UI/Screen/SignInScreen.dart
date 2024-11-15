import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/UI/Controllers/sign_in_controller.dart';
import 'package:task_manager/UI/Screen/Forgot_password_Email_Screen.dart';
import 'package:task_manager/UI/Screen/SingUpScreen.dart';
import 'package:task_manager/UI/Utils/app_colors.dart';
import 'package:task_manager/UI/Widgets/screenBackground.dart';

import '../Widgets/Center_Circular_Progress_Indicator.dart';
import '../Widgets/SnackBarMessage.dart';
import 'Main_Button_NavBar_Screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String signInScreen = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  final SignInController signInController = Get.find<SignInController>();

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
                "Get Started With",
                style: textTheme.displaySmall
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              SignInForm(),
              const SizedBox(
                height: 30,
              ),
              buildSignUpSection()
            ],
          ),
        ),
      )),
    );
  }

  Widget buildSignUpSection() {
    return Center(
      child: Column(
        children: [
          TextButton(
            onPressed: onTapForgotButton,
            child: const Text("Forgot Password?"),
          ),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.5),
              text: "Don't have an account? ",
              children: [
                TextSpan(
                  style: const TextStyle(color: AppColors.themeColor),
                  text: 'Sign Up',
                  recognizer: TapGestureRecognizer()..onTap = onTapSignUp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onTapForgotButton() {
    Get.toNamed(FotgotPasswordEmailScreen.otpScreen);
  }

  Widget SignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Email",
            ),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Enter Email';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: passwordCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Password",
            ),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Enter password';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          GetBuilder<SignInController>(
            builder: (controller) {
              return Visibility(
                visible: !controller.inprogress,
                replacement: const CenterCircularProgressIndicator(),
                child: ElevatedButton(
                  onPressed: onTapNextButton,
                  child: const Icon(Icons.arrow_circle_right_outlined),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void onTapNextButton() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    signInSystem();
  }

  Future<void> signInSystem() async {
    final bool result =
        await signInController.signInSystem(emailCtrl.text, passwordCtrl.text);

    if (result) {
      Get.offAllNamed(MainButtonNavbarScreen.homeScreen);
    } else {
      showSnackBarMessage(context, signInController.errorMessage!, true);
    }
  }

  void onTapSignUp() {
    Get.toNamed(SignUpScreen.signUpScreen);
  }
}
