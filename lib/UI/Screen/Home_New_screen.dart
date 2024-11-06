import 'package:flutter/material.dart';
import 'package:task_manager/Data/Models/Network_Response.dart';
import 'package:task_manager/Data/Models/TaskListModel.dart';
import 'package:task_manager/Data/Services/Network_Caller.dart';
import 'package:task_manager/Data/Utils/Urls.dart';
import 'package:task_manager/UI/Controllers/auth_controller.dart';
import 'package:task_manager/UI/Screen/New_task_screen.dart';
import 'package:task_manager/UI/Widgets/SnackBarMessage.dart';
import 'package:task_manager/UI/Widgets/Task_Summary_Card.dart';

import '../../Data/Models/StatusCountModel.dart';
import '../Widgets/Task_Card.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  bool getDataIndicator = false;
  List newTaskList = [];

  bool statusCountInprogress = false;
  List statusCountList = [];

  @override
  void initState() {
    super.initState();
    getNewTaskData();
    getTaskStatusCount();
    AuthController.getUserData();
    print(AuthController.getUserData());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildSummarySection(),
          Expanded(
              child: Visibility(
            visible: !getDataIndicator,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: ListView.separated(
              itemCount: newTaskList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskData: newTaskList[index], onRefreshList: getNewTaskData,
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 8,
                );
              },
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onTapNextFAB,
        child: const Icon(Icons.add),
      ),
    );
  }

  Padding buildSummarySection() {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: getTaskSummaryList(),
            
          
        ),
      ),
    );
  }

  List<TaskSummary> getTaskSummaryList (){
    List<TaskSummary> taskSummaryList = [];
    for(Data t in statusCountList){
         taskSummaryList.add(TaskSummary(title: t.sId!,count: t.sum!,));
    }
    return taskSummaryList;
  }
  

  void onTapNextFAB() async {
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewTaskScreen(),
      ),
    );

    if (shouldRefresh == true) {
      getNewTaskData();
    }
  }

  Future<void> getNewTaskData() async {
    getDataIndicator = true;
    setState(() {});

    NetworkResponse response = await NetworkCaller.getRequest(Urls.showNewTask);

    if (response.isSuccess) {
      final TaskListModel taskListModel =
          TaskListModel.fromJson(response.responseData);
      newTaskList = taskListModel.tasklist ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }

    getDataIndicator = false;
    setState(() {});
  }


  Future<void> getTaskStatusCount() async {
    statusCountInprogress = true;
    setState(() {});

    NetworkResponse response = await NetworkCaller.getRequest(Urls.taskStatusCount);

    if (response.isSuccess) {
      final StatusCountModel statusCountModel =
          StatusCountModel.fromJson(response.responseData);
      statusCountList = statusCountModel.statusCountData ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }

    statusCountInprogress = false;
    setState(() {});
  }
}
