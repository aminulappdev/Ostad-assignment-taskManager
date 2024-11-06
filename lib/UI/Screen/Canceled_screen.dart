import 'package:flutter/material.dart';

import '../../Data/Models/Network_Response.dart';
import '../../Data/Models/TaskListModel.dart';
import '../../Data/Services/Network_Caller.dart';
import '../../Data/Utils/Urls.dart';
import '../Widgets/SnackBarMessage.dart';
import '../Widgets/Task_Card.dart';

class CancelScreen extends StatefulWidget {
  const CancelScreen({super.key});
  

  @override
  State<CancelScreen> createState() => _CancelScreenState();
}

class _CancelScreenState extends State<CancelScreen> {
  List canceledTaskList = [];
  bool canceledTaskInpogress = false;

  @override
  void initState() {
    super.initState();
    canceledTaskData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: canceledTaskList.length,
      itemBuilder: (context, index) {
        return TaskCard(
          taskData: canceledTaskList[index], onRefreshList: canceledTaskData,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 8,
        );
      },
    );
  }

  Future<void> canceledTaskData() async {
    canceledTaskInpogress = true;
    setState(() {});

    final NetworkResponse response =
        await NetworkCaller.getRequest(Urls.showCanceledTask);

    if (response.isSuccess) {
      final TaskListModel taskListModel =
          TaskListModel.fromJson(response.responseData);
      canceledTaskList = taskListModel.tasklist ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }

    canceledTaskInpogress = false;
    setState(() {});
  }
}
