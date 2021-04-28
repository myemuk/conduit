#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';

import '../../db_settings.dart';
import '../../postgres_manager.dart';

/// This script will run the conduit unit tests
///
/// To run this script install dcli:
///
/// ```pub global activate dcli
/// ```
///
/// Then you can run:
///
/// ```
/// ./run_unit_tests.dart
/// ```
///
void main(List<String> args) {
  final projectRoot = DartProject.current.pathToProjectRoot;
  final pathToToolDir = join(projectRoot, 'tool');
  var dbSettings = DbSettings.load(pathToSettings: pathToToolDir);
  dbSettings.createEnvironmentVariables();

  var postgresManager = PostgresManager(dbSettings);

  print('Stopping posgress docker image');
  postgresManager.stopPostgresDaemon(pathToToolDir);
}

// void activate(String projectRoot,  package) {
//   'pub global activate $package --source=path'.start(
//       workingDirectory: truepath(projectRoot, '..'));
// }
