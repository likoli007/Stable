import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/app_wrapper.dart';
import 'package:stable/database/service/database_service.dart';
import 'package:stable/page/task/task_view.dart';
import 'package:stable/service/task_service.dart';
import 'package:stable/firebase_options.dart';
import 'package:stable/model/task/task.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  GetIt.instance.registerSingleton(
    DatabaseService<Task>('Task',
        fromJson: Task.fromJson, toJson: (task) => task.toJson()),
  );
  GetIt.instance
      .registerSingleton(TaskService(GetIt.instance<DatabaseService<Task>>()));
  runApp(const AppWrapper());
}
