import 'dart:io';
import 'package:typeredis/typeredis.dart' show TRLogger;

typedef TypeRedis = TRLogger; // TODO: remove after TR is changed

TypeRedis logger = TypeRedis('Setup')..setLogLevelInfo();

void main() {
  // logger.info('Checking for $env file...');
  // checkEnvFile();

  logger.info('Running pub get...');
  pubGet();

  logger.info('Running flappy_translator...');
  flappyTranslator();

  // // logger.info('Running flutter_native_splash...');
  // flutterNativeSplash();

  // // logger.info('Running flutter_launcher_icons...');
  // flutterLauncherIcons();

  // // logger.info('Running dart_pubspec_licenses...');
  // dartPubspecLicenses();

  // // logger.info('Running generating VkAppIcons...');
  // vkAppIcons();

  // // logger.info('Running build_runner...');
  // buildRunner();
}

// void checkEnvFile() {
//   const env = '.env';
// logger.info('Filename: $env file...');
//   final envFile = File(env);
//   if (envFile.existsSync()) {
//     logger.info('$env file found. Proceeding...');
//     return;
//   } else {
//     logger.error(
//       'CRITICAL: $env file not found. Setup cannot continue. Terminating.');
//     exit(1);
//   }
// }

void pubGet() {
  final result = Process.runSync('dart', ['pub', 'get']);
  if (result.exitCode != 0) {
    logger
      ..setLogLevelError()
      ..error('pub get FAILED with exit code ${result.exitCode}.')
      ..error(result.stderr.toString());
    exit(result.exitCode);
  }
  logger.info(result.stdout.toString());
}

void flappyTranslator() {
  final result = Process.runSync('dart', ['run', 'flappy_translator']);
  if (result.exitCode != 0) {
    logger
      ..setLogLevelError()
      ..error('flappy_translator FAILED with exit code ${result.exitCode}.')
      ..error(result.stderr.toString());
    exit(result.exitCode);
  }
  logger.info(result.stdout.toString());
}

// void flutterNativeSplash() {
//   final result =
//       Process.runSync('dart', ['run', 'flutter_native_splash:create']);
//   if (result.exitCode != 0) {
//     logger
//       ..setLogLevelError()
//       ..error(
//           'flutter_native_splash FAILED with exit code ${result.exitCode}.')
//       ..error(result.stderr.toString());
//     exit(result.exitCode);
//   }
//   logger.log(result.stdout.toString());
// }

// void flutterLauncherIcons() {
//   final result = Process.runSync('dart', ['run', 'flutter_launcher_icons']);
//   if (result.exitCode != 0) {
//     logger
//       ..setLogLevelError()
//       ..error(
//           'flutter_launcher_icons FAILED with exit code ${result.exitCode}.')
//       ..error(result.stderr.toString());
//     exit(result.exitCode);
//   }
//   logger.log(result.stdout.toString());
// }

// void dartPubspecLicenses() {
//   final result =
//       Process.runSync('dart', ['run', 'dart_pubspec_licenses:generate']);
//   if (result.exitCode != 0) {
//     logger
//       ..setLogLevelError()
//       ..error(
//           'dart_pubspec_licenses FAILED with exit code ${result.exitCode}.')
//       ..error(result.stderr.toString());
//     exit(result.exitCode);
//   }
//   logger.log(result.stdout.toString());
// }

// void vkAppIcons() {
//   final result = Process.runSync('dart', [
//     'tool/generate_vk_app_icon_map.dart',
//   ]);
//   if (result.exitCode != 0) {
//     logger
//       ..setLogLevelError()
//       ..error('pub get FAILED with exit code ${result.exitCode}.')
//       ..error(result.stderr.toString());
//     exit(result.exitCode);
//   }
//   logger.log(result.stdout.toString());
// }

// void buildRunner() {
//   final result = Process.runSync(
//       'dart', ['run', 'build_runner', 'build',
//       '--delete-conflicting-outputs']);
//   if (result.exitCode != 0) {
//     logger
//       ..setLogLevelError()
//       ..error('build_runner FAILED with exit code ${result.exitCode}.')
//       ..error(result.stderr.toString());
//     exit(result.exitCode);
//   }
//   logger.log(result.stdout.toString());
// }
