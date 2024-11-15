import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/UI/Controllers/get_status_count_controller.dart';
import 'package:task_manager/UI/Controllers/new_taskList_controller.dart';
import 'package:task_manager/UI/Screen/New_task_screen.dart';
import 'package:task_manager/UI/Widgets/SnackBarMessage.dart';
import 'package:task_manager/UI/Widgets/Task_Summary_Card.dart';

import '../../Data/Models/StatusCountModel.dart';
import '../Widgets/Task_Card.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});
  static const String newScreen = '/new-screen';

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  final NewTaskListController newTaskListController =
      Get.find<NewTaskListController>();

  final GetStatusCountController getStatusCountController = Get.find<GetStatusCountController>();

  

  @override
  void initState() {
    super.initState();
    getNewTaskData();
    getTaskStatusCount();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildSummarySection(),
          Expanded(child: GetBuilder<NewTaskListController>(
            builder: (controller) {
              return Visibility(
                visible: !controller.inprogress,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: ListView.separated(
                  itemCount: controller.newTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskData: controller.newTaskList[index],
                      onRefreshList: getNewTaskData,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 8,
                    );
                  },
                ),
              );
            },
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: getTaskSummaryList(),
        ),
      ),
    );
  }

  List<TaskSummary> getTaskSummaryList() {
    print('Counter Value is : ${getStatusCountController.statusCountList}');
    List<TaskSummary> taskSummaryList = [];
    for (Data t in getStatusCountController.statusCountList) {
      taskSummaryList.add(TaskSummary(
        title: t.sId!,
        count: t.sum!,
      ));
    }
    return taskSummaryList;
  }

  void onTapNextFAB() async {

    final bool? shouldRefresh = await Get.to(()=> const NewTaskScreen());
    // final bool? shouldRefresh = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const NewTaskScreen(),
    //   ),
    // );

    if (shouldRefresh == true) {
      getNewTaskData();
    }
  }

  Future<void> getNewTaskData() async {
    final bool result = await newTaskListController.getNewTaskData();

    if (result != true) {
      showSnackBarMessage(context, newTaskListController.errorMessage!, true);
    }
  }

  Future<void> getTaskStatusCount() async {
    
    final bool result = await getStatusCountController.getTaskStatusCount();
 
    if (result != true) {
       showSnackBarMessage(context, getStatusCountController.errMessage!, true);
    } 
  }
}
