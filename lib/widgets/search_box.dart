import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state_management/state_of_todos.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
    required this.searchController,
  });

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final todo = Provider.of<TodoState>(context);

    return TextFormField(
      controller: searchController,
      onChanged: (value) {
        todo.searchData(value);
      },
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: TextStyle(color: Colors.grey[600]),
        // Subtle hint text color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          // Rounded corners
          borderSide: BorderSide.none, // Remove border line
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
              color: Colors.blueGrey.withOpacity(0.3),
              width: 1.0), // Subtle border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide:
          BorderSide(color: Colors.blue, width: 2.0), // Focus border
        ),
        filled: true,
        // Background color
        fillColor: Colors.white,
        // Background color of the text field
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          // Padding around icon
          child: Icon(Icons.search, color: Colors.blueGrey), // Icon color
        ),
        suffixIcon: IconButton(
          onPressed: () {
            searchController.clear();
            todo.clearSearchResults();
          },
          icon: Icon(Icons.close, color: Colors.blueGrey), // Icon color
        ),
        contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 15.0), // Padding inside the text field
      ),
    );
  }
}