import 'TaskModel.dart';

class TaskListModel {
  String? status;
  List<TaskData>? tasklist;

  TaskListModel({this.status, this.tasklist});

  TaskListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      tasklist = <TaskData>[];
      json['data'].forEach((v) {
        tasklist!.add(TaskData.fromJson(v));
      });
    }
  }


}

