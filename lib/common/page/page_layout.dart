import 'package:flutter/material.dart';
import 'package:stable/page/home/overview_page.dart';
import 'package:stable/page/household/households_list_page.dart';
import 'package:stable/page/task/user_task_page.dart';

class PageLayout extends StatefulWidget {
  @override
  _PageLayoutState createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _pageIndex,
          children: <Widget>[
            OverviewPage(),
            HouseholdsListPage(),
            UserTaskPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // TODO play with this modes
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.maps_home_work),
            label: 'Households',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: 'Tasks',
          ),
        ],
        currentIndex: _pageIndex,
        onTap: (int index) {
          setState(
            () {
              _pageIndex = index;
            },
          );
        },
      ),
    );
  }
}
