import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/UI/Controllers/complete_screen_controller.dart';

import '../Widgets/SnackBarMessage.dart';
import '../Widgets/Task_Card.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  static const String completedScreen = '/completed-screen';

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  final CompleteScreenController completeScreenController =
      Get.find<CompleteScreenController>();

  bool completedTaskInpogress = false;
  List completedTaskList = [];

  @override
  void initState() {
    super.initState();
    completedTaskData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompleteScreenController>(
      builder: (controller) {
        return Visibility(
          visible: !controller.inprogress,
          replacement: const Center(child: CircularProgressIndicator()),
          child: ListView.separated(
            itemCount: controller.completeTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskData: controller.completeTaskList[index],
                onRefreshList: completedTaskData,
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
    );
  }

  Future<void> completedTaskData() async {
    final bool result = await completeScreenController.completedTaskData();

    if (result != true) {
      showSnackBarMessage(
          context, completeScreenController.errorMessage!, true);
    }
  }
}
