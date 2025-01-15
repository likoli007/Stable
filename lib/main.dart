import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import 'package:stable/app/widget/app_wrapper.dart';
import 'package:stable/auth/firebase_auth_service.dart';
import 'package:stable/ui/common/theme/app_theme_factory.dart';
import 'package:stable/database/service/database_service.dart';
import 'package:stable/model/inhabitant/inhabitant.dart';
import 'package:stable/server/TaskUpdater.dart';
import 'package:stable/service/household_service.dart';
import 'package:stable/service/inhabitant_service.dart';
import 'package:stable/service/settings_controller.dart';
import 'package:stable/service/task_service.dart';
import 'package:stable/firebase_options.dart';
import 'package:stable/model/task/task.dart';
import 'package:stable/model/subtask/subtask.dart';
import 'package:stable/model/household/household.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file located in the assets folder
  await dotenv.load(fileName: "assets/.env");

  // Initialize Firebase platform
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase Auth providers
  GetIt.instance.registerSingleton<FirebaseAuthService>(FirebaseAuthService());

  // Register Firestore documents
  GetIt.instance.registerSingleton(
    DatabaseService<Task>('Task',
        fromJson: Task.fromJson, toJson: (task) => task.toJson()),
  );

  GetIt.instance.registerSingleton(
    DatabaseService<Subtask>(
      'Subtask',
      fromJson: Subtask.fromJson,
      toJson: (subtask) => subtask.toJson(),
    ),
  );

  GetIt.instance.registerSingleton(TaskService(
      GetIt.instance<DatabaseService<Task>>(),
      GetIt.instance<DatabaseService<Subtask>>()));

  GetIt.instance.registerSingleton(DatabaseService<Inhabitant>('User',
      fromJson: Inhabitant.fromJson,
      toJson: (inhabitant) => inhabitant.toJson()));

  GetIt.instance.registerSingleton(
      InhabitantService(GetIt.instance<DatabaseService<Inhabitant>>()));

  GetIt.instance.registerSingleton(DatabaseService<Household>('Household',
      fromJson: Household.fromJson, toJson: (household) => household.toJson()));

  GetIt.instance.registerSingleton(
      HouseholdService(GetIt.instance<DatabaseService<Household>>()));

  GetIt.instance.registerSingleton(TaskUpdater());

  // Theming
  GetIt.instance.registerSingleton(SettingsController());

  final lightThemeData = await AppThemeFactory.create(
    isDark: false,
  );
  final darkThemeData = await AppThemeFactory.create(
    isDark: true,
  );

  runApp(AppWrapper(
    lightThemeData: lightThemeData,
    darkThemeData: darkThemeData,
  ));
}
