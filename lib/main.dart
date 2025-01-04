import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/app/widget/app_wrapper.dart';
import 'package:stable/database/service/database_service.dart';
import 'package:stable/model/inhabitant/inhabitant.dart';
import 'package:stable/service/inhabitant_service.dart';
import 'package:stable/service/task_service.dart';
import 'package:stable/firebase_options.dart';
import 'package:stable/model/task/task.dart';

import 'package:stable/model/subtask/subtask.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file located in the assets folder
  await dotenv.load(fileName: ".env");

  // Initialize Firebase platform
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase Auth providers
  // For Google sign-in, you need to add the client ID to .env file
  // Client ID can be found in the Google Cloud Console
  FirebaseUIAuth.configureProviders([
    GoogleProvider(clientId: dotenv.env['GOOGLE_CLIENT_ID']!),
  ]);

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

  GetIt.instance.registerSingleton(DatabaseService<Inhabitant>('User',
      fromJson: Inhabitant.fromJson,
      toJson: (inhabitant) => inhabitant.toJson()));

  GetIt.instance.registerSingleton(
      UserService(GetIt.instance<DatabaseService<Inhabitant>>()));

  runApp(const AppWrapper());
}
