import 'package:get/get.dart';
import 'package:task_manager/Data/Models/ListModel.dart';
import 'package:task_manager/UI/Controllers/auth_controller.dart';

import '../../Data/Models/Network_Response.dart';
import '../../Data/Services/Network_Caller.dart';
import '../../Data/Utils/Urls.dart';

class SignInController extends GetxController {
  bool isSuccess = false;
  bool _inProgress = false;
  bool get inprogress => _inProgress; 
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  

  Future<bool> signInSystem(String email, String password) async {
    _inProgress = true;
    update();

    Map<String, dynamic> requestBody = {"email": email, "password": password};

    NetworkResponse response =
        await NetworkCaller.postRequest(Urls.login, requestBody);

    if (response.isSuccess) {
      print('ResponseData : ${response.responseData}');
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveAccessToken(loginModel.token.toString());
      await AuthController.saveUserData(loginModel.data!);

      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}
