import 'package:flutter/material.dart';

class TodoModel {
  int? id;
  String photoPath;
  String task;         // Task description
  String description;  // Description of the task
  DateTime date;       // Date of the task
  TimeOfDay time;      // Time of the task
  bool isDone;         // Completion status

 TodoModel({
    this.photoPath='',
    this.id,
    this.task = '',    // Default task description is empty
    this.description = '', // Default description is empty
    required this.date,   // Date is required
    required this.time,   // Time is required
    this.isDone = false   // Default isDone status is false (not done)
  });
  // Method to convert TodoModel object to JSON format for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photoPath': photoPath,
      'task': task,
      'description': description,                 // Description of the task
      'date': date.toIso8601String(),         // Convert DateTime to ISO 8601 String
      'time': '${time.hour}:${time.minute}', // Convert TimeOfDay to 'HH:MM' String
      'isDone': isDone ? 1 : 0,
    };
  }

  // Factory method to create a TodoModel object from a JSON map
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      photoPath: json['photoPath'],
      task: json['task'],                                 // Get task description
      description: json['description'],                   // Get description
      date: DateTime.parse(json['date']),                 // Parse ISO 8601 String to DateTime
      time: TimeOfDay(
        hour: int.parse(json['time'].split(':')[0]),      // Parse hour part from 'HH:MM'
        minute: int.parse(json['time'].split(':')[1]),    // Parse minute part from 'HH:MM'
      ),
      isDone: json['isDone']==1,                             // Get completion status
    );
  }
  @override
  String toString() {
    return 'TodoModel{id: $id, task: $task, description: $description, isDone: $isDone, photoPath:$photoPath}';
  }
}
