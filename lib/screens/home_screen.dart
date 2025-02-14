import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/screens/archive_screen.dart';
import 'package:todo_application/screens/main_create.dart';
import 'package:todo_application/state_management/state_of_todos.dart';

class HomeScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoState>(
      builder: (context, todo, child) {
        return WillPopScope(
          onWillPop: () async {
            if (_pageController.page != 0) {
              // If not on the first page, navigate to the previous page
              _pageController.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              return false; // Prevent closing the app
            }
            return true; // Allow closing the app if on the first page
          },
          child: Scaffold(
            body: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                MainCreate(),
                ArchiveScreen(),
              ],
              onPageChanged: (index) {
                todo.setSelectedIndex(index); // Update selected index
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: todo.selectedIndex,
              onTap: (index) {
                if (index != todo.selectedIndex) {
                  todo.changeIndex(index, _pageController); // Change page
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: "Current",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: "Archived",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
