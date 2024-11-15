import 'package:get/get.dart';
import 'package:task_manager/Data/Models/Network_Response.dart';
import 'package:task_manager/Data/Models/StatusCountModel.dart';
import 'package:task_manager/Data/Services/Network_Caller.dart';
import 'package:task_manager/Data/Utils/Urls.dart';

class GetStatusCountController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;
  String? _errorMessage;
  String? get errMessage => _errorMessage;
  List statusCountList = [];

  // List get statusCountList => _statusCountList;

  bool isSuccess = false;

  Future<bool> getTaskStatusCount() async {
    _inProgress = true;
    update();

    NetworkResponse response =
        await NetworkCaller.getRequest(Urls.taskStatusCount);

    if (response.isSuccess) {
      final StatusCountModel statusCountModel =
          StatusCountModel.fromJson(response.responseData);
      statusCountList = statusCountModel.statusCountData ?? [];
      print("Main function counter value : $statusCountList");
      
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();

    return isSuccess;
  }
}
