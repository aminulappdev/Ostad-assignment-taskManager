
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/UI/Controllers/send_OTP_controller.dart';
import 'package:task_manager/UI/Utils/app_colors.dart';
import 'package:task_manager/UI/Widgets/Center_Circular_Progress_Indicator.dart';
import 'package:task_manager/UI/Widgets/SnackBarMessage.dart';
import 'package:task_manager/UI/Widgets/screenBackground.dart';

import 'Forgot_Password_OTP_Screen.dart';

class FotgotPasswordEmailScreen extends StatefulWidget {
   FotgotPasswordEmailScreen({super.key});

   static const String otpScreen = '/otp-screen';

  @override
  State<FotgotPasswordEmailScreen> createState() =>
      _FotgotPasswordEmailScreenState();
}

class _FotgotPasswordEmailScreenState extends State<FotgotPasswordEmailScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  // final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final SendOtpController sendOtpController = Get.find<SendOtpController>();




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
                "Your Email Adress",
                style: textTheme.displaySmall
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                "A 6 digit varification otp will be send your email address",
                style: textTheme.titleMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(
                height: 20,
              ),
              buildEmailInputForm(),
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

  Widget buildEmailInputForm() {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Email",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GetBuilder<SendOtpController>(builder: (controller) {
            return Visibility(
            visible: !controller.inprogress,
            replacement: const CenterCircularProgressIndicator(),
            child: ElevatedButton(
              onPressed: onTapNextButton,
              child: const Icon(Icons.arrow_circle_right_outlined),
            ),
          );
          },)
        ],
      ),
    );
  }

  void onTapNextButton() {
    
      sendOTP();
  }

  Future<void> sendOTP() async {
    final bool result = await sendOtpController.sendOTP(emailCtrl.text);
    
    if (result) {
      showSnackBarMessage(context, "OTP has been sent");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  FotgotPasswordOtpScreen(),
          ));
    } else {
      showSnackBarMessage(context, "OTP failed sent", true);
    }
  }

  void onTapSignIn() {
    Navigator.pop(context);
  }
}
