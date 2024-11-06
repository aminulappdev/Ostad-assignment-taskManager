import 'package:flutter/material.dart';

import '../../Data/Models/Network_Response.dart';
import '../../Data/Models/TaskListModel.dart';
import '../../Data/Services/Network_Caller.dart';
import '../../Data/Utils/Urls.dart';
import '../Widgets/SnackBarMessage.dart';
import '../Widgets/Task_Card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool progressedTaskInpogress = false;
  List progressedTaskList = [];

  @override
  void initState() {
    super.initState();
    progressedTaskData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: progressedTaskList.length,
      itemBuilder: (context, index) {
        return TaskCard(
          taskData: progressedTaskList[index], onRefreshList: progressedTaskData,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 8,
        );
      },
    );
  }

  Future<void> progressedTaskData() async {
    progressedTaskInpogress = true;
    setState(() {});

    final NetworkResponse response =
        await NetworkCaller.getRequest(Urls.showProgressedTask);

    if (response.isSuccess) {
      final TaskListModel taskListModel =
          TaskListModel.fromJson(response.responseData);
      progressedTaskList = taskListModel.tasklist ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }

    progressedTaskInpogress = false;
    setState(() {});
  }
}
