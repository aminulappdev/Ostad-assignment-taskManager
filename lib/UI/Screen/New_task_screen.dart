import 'package:flutter/material.dart';
import 'package:task_manager/Data/Models/Network_Response.dart';
import 'package:task_manager/Data/Services/Network_Caller.dart';
import 'package:task_manager/Data/Utils/Urls.dart';
import 'package:task_manager/UI/Widgets/TM_AppBar.dart';

import '../Widgets/SnackBarMessage.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController desCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool indicatorProgress = false;
  bool refreshPreviousPage = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop,) {
        if(didPop)
        {
          return;
        }
        Navigator.pop(context,refreshPreviousPage);
      },
      child: Scaffold(
        appBar:  TMappBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Add New Task',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: titleCtrl,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Enter title';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: 'Title'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: desCtrl,
                  validator: (String? value) {
                    if (value!.isEmpty ) {
                      return 'Enter descrition';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: 'Description'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(onPressed: addTaskBTN, child: const Text("Add Task"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addTaskBTN() {
    if (_formKey.currentState!.validate()) {
      addNewTask();
    } else {}
  }

  Future<void> addNewTask() async {
    indicatorProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "title": titleCtrl.text.trim(),
      "description": desCtrl.text.trim(),
      "status": "New"
    };

    NetworkResponse response =
        await NetworkCaller.postRequest(Urls.creatTask, requestBody);

    indicatorProgress = false;
    setState(() {});

    if (response.isSuccess) {
      refreshPreviousPage = true;
      clearTaskData();
      showSnackBarMessage(context, 'New task added!');
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  void clearTaskData() {
    titleCtrl.clear();
    desCtrl.clear();
  }
}
