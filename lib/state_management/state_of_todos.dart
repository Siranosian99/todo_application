import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import '../logics/authenticator.dart';
import '../logics/image_picker.dart';
import '../format_converter/time_date.dart';
import '../notification/notifciation_method.dart';
import '../screens/main_create.dart';
import 'dart:convert';
import '../model/todo_model.dart';
import '../screens/archive_screen.dart';
import '../storage_database/sqflite_database.dart';

class TodoState extends ChangeNotifier {
  String networkImageUrl = 'images/img.jpg';
  Picker pickerr = Picker();
  int selectedIndex = 0;
  List<TodoModel> tasks = [];
  bool data = false;
  List<TodoModel> archive_tasks = [];
  bool checkTheme = false;
  bool isDoneC = false;

  int get flag => isDoneC ? 1 : 0;

  // int? id;
  String recognizedText = '';
  bool requiresAuth = false;
  bool authArchive = true;
  bool checker = false;
  bool isChanging = false;
  String? photoPath;
  String? img;
  SharedPreferences? prefs;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController descpController = TextEditingController();
  final TextEditingController taskController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  TodoState() {
    _initialize();
  }

  Future<void> _initialize() async {
    await isLocked();
    await init();
    await loadThemeState();
    await loadAuthState();
    await loadAuthStateArchive();
    tz.initializeTimeZones();
    await loadTasks();
    await loadArchiveTasks();
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> isLocked() async {
    checker = await AuthService.isDeviceSecure();
  }

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners(); // Notify listeners when the index changes
  }

  Future<void> changeIndex(int index, PageController pageController) async {
    if (index == 1) {
      bool isAuthenticated = await AuthService.authenticate(authArchive);
      if ((isAuthenticated && !checker) ||
          (isAuthenticated && checker) ||
          (!isAuthenticated && !checker)) {
        // Change the page using the PageController
        pageController.jumpToPage(index);
        selectedIndex = index;
        notifyListeners();
      } else {
        // Reset to the main page if not authenticated
        pageController.jumpToPage(0);
        selectedIndex = 0;
        notifyListeners();
      }
    } else if (index == 0) {
      // Change the page to MainCreate
      pageController.jumpToPage(index);
      selectedIndex = index;
      notifyListeners();
    }
  }

  bool checkData() {
    data = tasks.isEmpty ? false : true;
    return data;
  }

  void clearImg() {
    photoPath = null;
    notifyListeners();
  }

  Future<void> pickAndRecognizeText(
      ImageSource source, TextEditingController taskController) async {
    await pickerr.pickImage(source);
    String text = await pickerr.recognizeText();
    recognizedText = text;
    taskController.text += " " + recognizedText;
    notifyListeners();
  }

  Future<void> pickImage(int index, {bool notify = false}) async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      photoPath = image.path;
      tasks[index].photoPath = photoPath!;

      if (notify) {
        notifyListeners();
      }
    }
  }


  void checkThemes(bool value) {
    checkTheme = value;
    saveThemeState();
    notifyListeners();
  }

  void clearSearchResults() {
    loadTasks(); // Reset tasks list to original state
  }

  // int generateUniqueId() {
  //   id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
  //   return id;
  // }

  void searchData(String query) async {
    List<TodoModel> taskList = await TodoDatabase.getNotes();
    if (query.isEmpty) {
      await loadTasks();
    } else if (taskList != null) {
      tasks = taskList
          .where((task) =>
              task.task.toLowerCase().contains(query.toLowerCase()) ||
              task.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
      notifyListeners();
    }
    notifyListeners();
  }

  // Future<void> addToList(TodoModel task) async {
  //   // tasks.add(task);
  //   // saveTasks();
  //   // id = await TodoDatabase.insertNote(task);
  //   // Now you can pass this ID into other methods
  //   doSomethingWithId(id!);
  //   notifyListeners();
  // }
  Future<void> addToList(TodoModel todo) async {
    int newId = await TodoDatabase.insertNote(todo);
    todo.id = newId;
    tasks.add(todo);
    notifyListeners();
  }

  void addToArchive(TodoModel task, int index) {
    archive_tasks.add(task);
    TodoDatabase.insertArchive(task, index);
    saveArchiveTasks();
    removeFromList(index);
    notifyListeners();
  }

  void removeFromList(int index) {
    final id = tasks[index].id ?? 0;
    tasks.removeAt(index);
    // saveTasks();
    TodoDatabase.deleteNote(id);
    notifyListeners();
  }

  void removeFromListArchive(int index) {
    archive_tasks.removeAt(index);
    saveArchiveTasks();
    notifyListeners();
  }

  void changeStatus(int index) async {
    tasks[index].isDone = !tasks[index].isDone;
    // await TodoDatabase.updateNote(
    //     tasks[index].id ?? 0, tasks[index]); // If you have this method
    notifyListeners();
  }

  void changeArchiveStatus(int index) {
    archive_tasks[index].isDone = !archive_tasks[index].isDone;
    saveTasks();
    notifyListeners();
  }

  Future<void> saveTasks() async {
    List<String> taskList =
        tasks.map((task) => json.encode(task.toJson())).toList();
    prefs?.setStringList('tasks', taskList);
  }

  Future<void> saveArchiveTasks() async {
    List<String> archiveTaskList =
        archive_tasks.map((task) => json.encode(task.toJson())).toList();
    prefs?.setStringList('archive_tasks', archiveTaskList);
  }

  Future<void> loadTasks() async {
    // List<String>? taskList = prefs?.getStringList('tasks');
    // if (taskList != null) {
    //   tasks = taskList
    //       .map((task) => TodoModel.fromJson(json.decode(task)))
    //       .toList();
    // }
    tasks = await TodoDatabase.getNotes();
    notifyListeners();
  }

  Future<void> loadArchiveTasks() async {
    List<String>? archiveTaskList = prefs?.getStringList('archive_tasks');
    if (archiveTaskList != null) {
      archive_tasks = archiveTaskList
          .map((task) => TodoModel.fromJson(json.decode(task)))
          .toList();
    }
    notifyListeners();
  }

  void toggleAuthApp() async {
    requiresAuth = !requiresAuth;
    notifyListeners();
    await saveAuthState();
  }

  //  void updateTask(int index, TodoModel updatedTask) {
  //   if (index >= 0 && index < tasks.length) {
  //     TodoModel currentTask = tasks[index];
  //
  //     // Create DateTime object for the updated task's scheduled notification
  //     DateTime scheduledTime = DateTime(
  //       updatedTask.date.year,
  //       updatedTask.date.month,
  //       updatedTask.date.day,
  //       updatedTask.time.hour,
  //       updatedTask.time.minute,
  //     );
  //
  //     // Check if any changes were made
  //     if (currentTask.task != updatedTask.task ||
  //         currentTask.description != updatedTask.description ||
  //         currentTask.date != updatedTask.date ||
  //         currentTask.time != updatedTask.time ||
  //         currentTask.photoPath != updatedTask.photoPath) {
  //       tasks[index] = updatedTask;
  //
  //       NotificationMethod.flutterLocalNotificationsPlugin
  //           .cancel(currentTask.id.hashCode);
  //
  //       NotificationMethod.scheduleNotification(
  //           updatedTask.id ?? 0, scheduledTime, updatedTask.task);
  //
  //       saveTasks();
  //       notifyListeners();
  //     }
  //   }
  // }
  void updateTask(int id, TodoModel todo) async {
    TodoDatabase.updateNote(id, todo);
    await loadTasks();
    DateTime scheduledTime = DateTime(
      todo.date.year,
      todo.date.month,
      todo.date.day,
      todo.time.hour,
      todo.time.minute,
    );
    NotificationMethod.flutterLocalNotificationsPlugin.cancel(todo.id.hashCode);

    NotificationMethod.scheduleNotification(
        todo.id ?? 0, scheduledTime, todo.task);
    notifyListeners();
  }

  void toggleAuthArchive() async {
    authArchive = !authArchive;
    notifyListeners();
    await saveAuthStateArch();
  }

  Future<void> loadAuthState() async {
    requiresAuth = prefs?.getBool('requiresAuth') ?? false;
    notifyListeners();
  }

  Future<void> saveAuthStateArch() async {
    await prefs?.setBool('authArchive', authArchive);
  }

  Future<void> loadAuthStateArchive() async {
    authArchive = prefs?.getBool('authArchive') ?? false;
    notifyListeners();
  }

  Future<void> saveAuthState() async {
    await prefs?.setBool('requiresAuth', requiresAuth);
  }

  Future<void> saveThemeState() async {
    if (prefs == null) return;
    await prefs!.setBool('ThemeState', checkTheme);
  }

  Future<void> loadThemeState() async {
    if (prefs == null) return;
    checkTheme = prefs!.getBool('ThemeState') ?? false;
    notifyListeners();
  }
}
