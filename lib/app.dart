import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/UI/Screen/Canceled_screen.dart';
import 'package:task_manager/UI/Screen/Completed_screen.dart';
import 'package:task_manager/UI/Screen/Forgot_Password_OTP_Screen.dart';
import 'package:task_manager/UI/Screen/Forgot_password_Email_Screen.dart';
import 'package:task_manager/UI/Screen/Home_New_screen.dart';
import 'package:task_manager/UI/Screen/Main_Button_NavBar_Screen.dart';
import 'package:task_manager/UI/Screen/New_task_screen.dart';
import 'package:task_manager/UI/Screen/Profile_Screen.dart';
import 'package:task_manager/UI/Screen/Progress_screen.dart';
import 'package:task_manager/UI/Screen/Reset_Passowrd_screen.dart';
import 'package:task_manager/UI/Screen/SignInScreen.dart';
import 'package:task_manager/UI/Screen/SingUpScreen.dart';
import 'package:task_manager/UI/Utils/app_colors.dart';
import 'package:task_manager/binding.dart';
import 'UI/Screen/SplashScreen.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});
  
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {

  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: StateBinder(),
      debugShowCheckedModeBanner: false,
      navigatorKey: TaskManagerApp.navigatorKey,
      theme: ThemeData(  
        colorSchemeSeed: AppColors.themeColor,
        textTheme: const TextTheme(),
        inputDecorationTheme: inputDecoration(),
        elevatedButtonTheme: elevatedBottunThemeData()
        
      ),
      initialRoute: '/',
      routes: {
         
         SplashScreen.splashScreen:  (context) => const SplashScreen(),
         SignInScreen.signInScreen:  (context) => const SignInScreen(),
         SignUpScreen.signUpScreen:  (context) => const SignUpScreen(),
         FotgotPasswordOtpScreen.varificationScreen:  (context) => FotgotPasswordOtpScreen(),
         FotgotPasswordEmailScreen.otpScreen:  (context) =>  FotgotPasswordEmailScreen(),
         ResetPasswordScreen.resetPasswordScreen:  (context) =>  ResetPasswordScreen(),
         ProfileScreen.updateProfileScreen:  (context) =>  const ProfileScreen(),
         
         
         MainButtonNavbarScreen.homeScreen:  (context) => const MainButtonNavbarScreen(),
         NewScreen.newScreen:  (context) => const NewScreen(),
         CompletedScreen.completedScreen:  (context) => const CompletedScreen(),
         CancelScreen.canceledScreen:  (context) => const CancelScreen(),
         ProgressScreen.progressScreen:  (context) => const ProgressScreen(),       
         NewTaskScreen.addScreen:  (context) => const NewTaskScreen(),       

      },
    );
    
  }


  InputDecorationTheme inputDecoration() {
    return InputDecorationTheme(
      hintStyle: const TextStyle(fontWeight: FontWeight.w300),
      fillColor: Colors.white,
      filled: true,
      border: inputBorder(),
      enabledBorder: inputBorder(),
      focusedBorder: inputBorder(),
      errorBorder: inputBorder(),
    );
  }

  OutlineInputBorder inputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    );
  }

  
  ElevatedButtonThemeData elevatedBottunThemeData() {
    return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.themeColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          fixedSize: const Size.fromWidth(double.maxFinite),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          )
        ),
      );
  }
}
