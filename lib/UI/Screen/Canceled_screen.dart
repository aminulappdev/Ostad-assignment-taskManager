import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/UI/Controllers/canceled_taskData_controller.dart';
import '../Widgets/SnackBarMessage.dart';
import '../Widgets/Task_Card.dart';

class CancelScreen extends StatefulWidget {
  const CancelScreen({super.key});

  static const String canceledScreen = '/canceled-screen';

  @override
  State<CancelScreen> createState() => _CancelScreenState();
}

class _CancelScreenState extends State<CancelScreen> {
  final CanceledTaskdataController canceledTaskdataController =
      Get.find<CanceledTaskdataController>();
  List canceledTaskList = [];
  bool canceledTaskInpogress = false;

  @override
  void initState() {
    super.initState();
    canceledTaskData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CanceledTaskdataController>(builder: (controller) {
        return ListView.separated(
      itemCount: controller.cancelTaskList.length,
      itemBuilder: (context, index) {
        return TaskCard(
          taskData: controller.cancelTaskList[index],
          onRefreshList: canceledTaskData,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 8,
        );
      },
    );
    },);
  }

  Future<void> canceledTaskData() async {
    final bool result = await canceledTaskdataController.canceledTaskData();

    if (result != true) {
      showSnackBarMessage(
          context, canceledTaskdataController.errorMessage!, true);
    }
  }
}
