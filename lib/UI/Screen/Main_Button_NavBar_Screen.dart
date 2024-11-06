import 'package:flutter/material.dart';
import 'package:task_manager/UI/Screen/Canceled_screen.dart';
import 'package:task_manager/UI/Screen/Completed_screen.dart';
import 'package:task_manager/UI/Screen/Progress_screen.dart';
import 'package:task_manager/UI/Screen/Home_New_screen.dart';
import 'package:task_manager/UI/Widgets/TM_AppBar.dart';

class MainButtonNavbarScreen extends StatefulWidget {
  const MainButtonNavbarScreen({super.key});

  @override
  State<MainButtonNavbarScreen> createState() => _MainButtonNavbarScreenState();
}

class _MainButtonNavbarScreenState extends State<MainButtonNavbarScreen> {
  int selectedKey = 0;
  List<Widget> screens = const [
    NewScreen(),
    CompletedScreen(),
    CancelScreen(),
    ProgressScreen()
  ];
  
  @override
  void initState() {
    super.initState();
    print('Hello im main screen');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMappBar(),
      body: screens[selectedKey],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedKey,
        onDestinationSelected: (index) {
          selectedKey = index;
          setState(() {});
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.new_label), label: 'New'),
          NavigationDestination(
              icon: Icon(Icons.check_box), label: 'Completed'),
          NavigationDestination(icon: Icon(Icons.close), label: 'Canceled'),
          NavigationDestination(icon: Icon(Icons.circle), label: 'Progress'),
        ],
      ),
    );
  }
}
