import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/Data/Models/Network_Response.dart';
import 'package:task_manager/Data/Services/Network_Caller.dart';
import 'package:task_manager/Data/Utils/Urls.dart';
import 'package:task_manager/UI/Utils/app_colors.dart';
import 'package:task_manager/UI/Widgets/screenBackground.dart';
import '../Widgets/Center_Circular_Progress_Indicator.dart';
import '../Widgets/SnackBarMessage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController PassCtrl = TextEditingController();

  bool inProgress = false;

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
                "Join With Us",
                style: textTheme.displaySmall
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              SignUpForm(),
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

  Widget SignUpForm() {
    return Form(
      key: _globalKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            controller: emailCtrl,
            decoration: const InputDecoration(
              hintText: "Email",
            ),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter Valid Email';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: firstNameCtrl,
            decoration: const InputDecoration(
              hintText: "First Name",
            ),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter Valid First name';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: lastNameCtrl,
            decoration: const InputDecoration(
              hintText: "Last Name",
            ),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter Valid last name';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: "Mobile",
            ),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter Valid number';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: PassCtrl,
            decoration: const InputDecoration(
              hintText: "Password",
            ),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter Valid password';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: !inProgress,
            replacement: const CenterCircularProgressIndicator(),
            child: ElevatedButton(
              onPressed: onTapNextButton,
              child: const Icon(Icons.arrow_circle_right_outlined),
            ),
          ),
        ],
      ),
    );
  }

  void onTapNextButton() {
    if (_globalKey.currentState!.validate()) {
      signUp();
    }
  }

  Future<void> signUp() async {
    inProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": emailCtrl.text.trim(),
      "firstName": firstNameCtrl.text.trim(),
      "lastName": lastNameCtrl.text.trim(),
      "mobile": phoneCtrl.text.trim(),
      "password": PassCtrl.text.trim(),
      "photo": ""
    };

    NetworkResponse response =
        await NetworkCaller.postRequest(Urls.registration, requestBody);

    inProgress = false;
    setState(() {});

    if (response.isSuccess) {

      
      clearTextField();
      showSnackBarMessage(context, 'New user created');
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  void clearTextField() {
    emailCtrl.clear();
    firstNameCtrl.clear();
    lastNameCtrl.clear();
    phoneCtrl.clear();
    PassCtrl.clear();
  }

  void onTapSignIn() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();

    emailCtrl.dispose();
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    phoneCtrl.dispose();
    PassCtrl.dispose();
  }
}
