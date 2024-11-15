import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/UI/Controllers/send_OTP_controller.dart';
import 'package:task_manager/UI/Controllers/varification_controller.dart';
import 'package:task_manager/UI/Screen/Reset_Passowrd_screen.dart';
import 'package:task_manager/UI/Screen/SignInScreen.dart';
import 'package:task_manager/UI/Utils/app_colors.dart';
import 'package:task_manager/UI/Widgets/SnackBarMessage.dart';
import 'package:task_manager/UI/Widgets/screenBackground.dart';


class FotgotPasswordOtpScreen extends StatefulWidget {
  FotgotPasswordOtpScreen({super.key});
  
  static const String varificationScreen = '/otp-screen/varification-screen';

  @override
  State<FotgotPasswordOtpScreen> createState() =>
      _FotgotPasswordOtpScreenState();
}

class _FotgotPasswordOtpScreenState extends State<FotgotPasswordOtpScreen> {
  final TextEditingController otpCtrl = TextEditingController();
  // final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final VarificationController varificationController =
      Get.find<VarificationController>();
  
  

  
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
                "Pin Varification",
                style: textTheme.displaySmall
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                "A 6 digit varification otp has been send your email address",
                style: textTheme.titleMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(
                height: 20,
              ),
              buildOTP_InputForm(),
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

  Widget buildOTP_InputForm() {
    return Column(
      children: [
        PinCodeTextField(
          controller: otpCtrl,
          length: 6,
          animationType: AnimationType.fade,
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
              inactiveFillColor: Colors.white,
              selectedFillColor: Colors.white),
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          enableActiveFill: true,
          appContext: context,
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: onTapNextButton,
          child: const Icon(Icons.arrow_circle_right_outlined),
        ),
      ],
    );
  }

  Future<void> onTapNextButton() async {
    final String userEmail = Get.find<SendOtpController>().userEmail ?? '';
    final bool result =
        await varificationController.varification(userEmail, otpCtrl.text);

    if (result) {
      showSnackBarMessage(context, 'Varification Done');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(),
        ),
      );
    } else {
      showSnackBarMessage(context, 'Invalid code', true);
    }
  }

  void onTapSignIn() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (_) => false);
  }
}
