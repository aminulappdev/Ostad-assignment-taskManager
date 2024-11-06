import 'package:flutter/material.dart';
import 'package:task_manager/Data/Models/Network_Response.dart';
import 'package:task_manager/Data/Models/TaskListModel.dart';
import 'package:task_manager/Data/Services/Network_Caller.dart';
import 'package:task_manager/Data/Utils/Urls.dart';

import '../Widgets/SnackBarMessage.dart';
import '../Widgets/Task_Card.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  bool completedTaskInpogress = false;
  List completedTaskList = [];

  @override
  void initState() {
    super.initState();
    completedTaskData();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !completedTaskInpogress,
      replacement: const Center(child: CircularProgressIndicator()),
      child: ListView.separated(
        itemCount: completedTaskList.length,
        itemBuilder: (context, index) {
          return  TaskCard(taskData: completedTaskList[index], onRefreshList: completedTaskData,);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 8,
          );
        },
      ),
    );
  }

  Future<void> completedTaskData() async {
    completedTaskInpogress = true;
    setState(() {});

    final NetworkResponse response =
        await NetworkCaller.getRequest(Urls.showCompletedTask);

    if (response.isSuccess) {
      final TaskListModel taskListModel =
          TaskListModel.fromJson(response.responseData);
      completedTaskList = taskListModel.tasklist ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }

    completedTaskInpogress = false;
    setState(() {});
  }
}
