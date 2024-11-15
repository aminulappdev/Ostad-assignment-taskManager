import 'package:get/get.dart';
import 'package:task_manager/UI/Controllers/add_task_controller.dart';
import 'package:task_manager/UI/Controllers/canceled_taskData_controller.dart';
import 'package:task_manager/UI/Controllers/complete_screen_controller.dart';
import 'package:task_manager/UI/Controllers/get_status_count_controller.dart';
import 'package:task_manager/UI/Controllers/new_taskList_controller.dart';
import 'package:task_manager/UI/Controllers/progress_screen_controller.dart';
import 'package:task_manager/UI/Controllers/reset_password_controller.dart';
import 'package:task_manager/UI/Controllers/send_OTP_controller.dart';
import 'package:task_manager/UI/Controllers/sign_in_controller.dart';
import 'package:task_manager/UI/Controllers/sign_up_controller.dart';
import 'package:task_manager/UI/Controllers/update_profile_controller.dart';
import 'package:task_manager/UI/Controllers/varification_controller.dart';

class StateBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(NewTaskListController());
    Get.put(GetStatusCountController());
    Get.put(CanceledTaskdataController());
    Get.put(CompleteScreenController());
    Get.put(ProgressScreenController());
    Get.put(SignUpController());
    Get.put(UpdateProfileController());
    Get.put(SendOtpController());
    Get.put(VarificationController());
    Get.put(ResetPasswordController());
    Get.put(AddTaskController());

  }
  
}