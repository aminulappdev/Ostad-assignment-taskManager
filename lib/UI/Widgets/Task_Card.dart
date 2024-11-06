import 'package:flutter/material.dart';
import 'package:task_manager/Data/Models/Network_Response.dart';
import 'package:task_manager/Data/Services/Network_Caller.dart';
import 'package:task_manager/UI/Widgets/Center_Circular_Progress_Indicator.dart';
import 'package:task_manager/UI/Widgets/SnackBarMessage.dart';

import '../../Data/Models/TaskModel.dart';
import '../../Data/Utils/Urls.dart';
import '../Utils/app_colors.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskData,
    required this.onRefreshList,
  });

  final TaskData taskData;
  final VoidCallback onRefreshList;
  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  String select_status = '';
  @override
  void initState() {
    super.initState();
    select_status = widget.taskData.status!;
  }

  bool changeStatusInprogressed = false;
  bool deleteStatusInprogressed = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.taskData.title ?? '',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(widget.taskData.description ?? ''),
            Text(widget.taskData.createdDate ?? ''),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildTaskStatusChip(),
                Wrap(
                  children: [
                    Visibility(
                      visible: !changeStatusInprogressed,
                      replacement: const CenterCircularProgressIndicator(),
                      child: IconButton(
                          onPressed: onTapEditButton,
                          icon: const Icon(Icons.edit)),
                    ),
                    Visibility(
                      visible: !deleteStatusInprogressed,
                      replacement: const CenterCircularProgressIndicator(),
                      child: IconButton(
                          onPressed: onTapDeleteButton,
                          icon: const Icon(Icons.delete)),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void onTapEditButton() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Edit Status"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
              ],
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      ['New', 'Completed', 'Canceled', 'Progressed'].map((e) {
                    return ListTile(
                      onTap: () {
                        changeStatusList(e);
                        Navigator.pop(context);
                      },
                      title: Text(e),
                      selected: select_status == e,
                      trailing:
                          select_status == e ? const Icon(Icons.check) : null,
                    );
                  }).toList()));
        });
  }

  Widget buildTaskStatusChip() {
    String taskStatus = widget.taskData.status ?? '';
    return Chip(
      label: Text(
        widget.taskData.status!,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: taskStatus == 'Canceled'
                ? const Color.fromARGB(255, 188, 96, 89)
                : taskStatus == 'Progressed'
                    ? const Color.fromARGB(255, 215, 215, 69)
                    : AppColors.themeColor,
          )),
    );
  }

  Future<void> changeStatusList(String status) async {
    changeStatusInprogressed = true;
    setState(() {});

    NetworkResponse response = await NetworkCaller.getRequest(
        Urls.updateTaskStatus(widget.taskData.sId!, status));

    if (response.isSuccess) {
      widget.onRefreshList();
    } else {
      changeStatusInprogressed = false;
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  Future<void> onTapDeleteButton() async {
    deleteStatusInprogressed = true;
    setState(() {});

    NetworkResponse response = await NetworkCaller.getRequest(
        Urls.deleteTaskStatus(widget.taskData.sId!));

    if (response.isSuccess) {
      widget.onRefreshList();
      showSnackBarMessage(context, 'Delete successfully done');
    } else {
      deleteStatusInprogressed = false;
      showSnackBarMessage(context, response.errorMessage);
    }
  }
}
