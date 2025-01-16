import 'package:flutter/material.dart';
import 'package:stable/ui/page/home/overview_page.dart';
import 'package:stable/ui/page/household/household_list_page/households_list_page.dart';
import 'package:stable/ui/page/task/user_task_page.dart';

class PageLayout extends StatefulWidget {
  @override
  PageLayoutState createState() => PageLayoutState();
}

class PageLayoutState extends State<PageLayout> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _pageIndex,
          children: <Widget>[
            HouseholdsListPage(),
            UserTaskPage(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _pageIndex,
      onTap: (int index) {
        setState(() {
          _pageIndex = index;
        });
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Households',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Tasks',
        ),
      ],
    );
  }
}
