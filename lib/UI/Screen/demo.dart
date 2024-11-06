import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

void main() {
  EmailOTP.config(
    appName: 'MyApp',
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v1,
  );

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController otpController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Email OTP')),
      body: ListView(
        children: [
          TextFormField(controller: emailController),
          ElevatedButton(
            onPressed: () async {
              if (await EmailOTP.sendOTP(email: emailController.text)) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("OTP has been sent")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("OTP failed sent")));
              }
            },
            child: const Text('Send OTP'),
          ),
          TextFormField(controller: otpController),
          ElevatedButton(
            onPressed: () => EmailOTP.verifyOTP(otp: otpController.text),
            child: const Text('Verify OTP'),
          ),
        ],
      ),
    );
  }
}