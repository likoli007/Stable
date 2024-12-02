import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:stable/app/widget/app_wrapper.dart';
import 'package:stable/authentication/auth_service.dart';
import 'package:stable/database/service/database_service.dart';
import 'package:stable/service/task_service.dart';
import 'package:stable/firebase_options.dart';
import 'package:stable/model/task/task.dart';

import 'model/subtask/subtask.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file located in the assets folder
  await dotenv.load(fileName: ".env");

  // Initialize Firebase platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register Firestore documents
  GetIt.instance.registerSingleton(
    DatabaseService<Task>('Task',
        fromJson: Task.fromJson, toJson: (task) => task.toJson()),
  );

  GetIt.instance.registerSingleton(DatabaseService<Subtask>('Subtask',
      fromJson: Subtask.fromJson, toJson: (subtask) => subtask.toJson()));

  GetIt.instance.registerSingleton(TaskService(
      GetIt.instance<DatabaseService<Task>>(),
      GetIt.instance<DatabaseService<Subtask>>()));

  // Start Firebase Authentication service
  GetIt.instance.registerSingleton(AuthService());

  runApp(const AppWrapper());
}
