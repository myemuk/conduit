#! /usr/bin/env dcli

import 'dart:io';

import 'package:conduit_common/conduit_common.dart';
import 'package:dcli/dcli.dart';
import 'package:conduit_dev_tools/conduit_dev_tools.dart';

/// Use this script to release all conduit packages
///
/// You should have run
void main(List<String> args) {
  // final parser = ArgParser();
  // parser.addFlag('test',
  //     defaultsTo: true,
  //     help: 'Runs all unit tests as part of the release process.');

  // if (!whichEx('critical_test')) {
  //   print('Installing global package critical_test');
  //   DartSdk().globalActivate('critical_test');
  // }
  // if (!whichEx('pub_release')) {
  //   print('Installing global package pub_release');
  //   DartSdk().globalActivate('pub_release');
  // }

  print('');
  print('');
  print(green('This will publish all Conduit packages to pub.dev.'));
  print(
      'Please ensure that all unit tests are passing before you run the release.');
  print('');
  if (!confirm(blue('Contiue to release all Conduit packages to pub.dev'))) {
    print(orange('Release cancelled.'));
    exit(1);
  }

  /// Required by conduit_config/test/config_test.dart
  env['TEST_VALUE'] = '1';
  env['TEST_BOOL'] = 'true';
  env['TEST_DB_ENV_VAR'] = 'postgres://user:password@host:5432/dbname';

  /// we use a fixed version no. for all of the projects.
  /// This avoid issues with pub publish bitching if some
  /// version no.s are beta releases and some not.
  DartProject conduitProject;
  if (exists('dev_tools')) {
    conduitProject = DartProject.fromPath('conduit');
  } else {
    conduitProject = DartProject.fromPath('.');
  }
  if (!conduitProject.hasPubSpec) {
    printerr(red("We can't find the conduit project folder"));
    printerr('You must run this script from within the Conduit mono repo');
    exit(1);
  }

  final pathToCiProjectRoot =
      join(conduitProject.pathToProjectRoot, '..', 'ci');

  runEx('pub_release',
      args: 'multi --no-test', workingDirectory: pathToCiProjectRoot);
}