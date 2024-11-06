class Urls {
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';

  static const String registration = '$_baseUrl/Registration';
  static const String login = '$_baseUrl/Login';
  static const String creatTask = '$_baseUrl/createTask';
  static const String showNewTask = '$_baseUrl/listTaskByStatus/New';
  static const String showCompletedTask =
      '$_baseUrl/listTaskByStatus/Completed';
  static const String showProgressedTask =
      '$_baseUrl/listTaskByStatus/Progressed';
  static const String showCanceledTask = '$_baseUrl/listTaskByStatus/Canceled';

  static String updateTaskStatus(String taskId, String status) {
    return '$_baseUrl/updateTaskStatus/$taskId/$status';
  }

  static String deleteTaskStatus(String taskId) {
    return '$_baseUrl/deleteTask/$taskId/';
  }

  static const String taskStatusCount = '$_baseUrl/taskStatusCount';
  static const String profileUpdate = '$_baseUrl/ProfileUpdate';

  static String recoveryVarifiedEmail (String email) {
    return '$_baseUrl/RecoverVerifyEmail/$email';
  }

  static String recoverVerifyOtp (String email, String otp) {
    return '$_baseUrl/RecoverVerifyOtp/$email/$otp';
  }

  static const String recoverResetPassword = '$_baseUrl/RecoverResetPassword';


}
