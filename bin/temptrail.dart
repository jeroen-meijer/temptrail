import 'dart:async';
import 'dart:io' as io;

import 'package:temptrail/src/cli_app.dart';
import 'package:temptrail/src/config.dart';
import 'package:temptrail/src/logging.dart';
import 'package:temptrail/src/version.dart';
import 'package:temptrail/temptrail.dart';

Future<void> main(List<String> args) async {
  log('${yellow(appName)} (version $packageVersion)');

  Config config;

  try {
    config = Config.fromArgs(args);
  } on ArgError catch (e) {
    log(red('Error: ${e.message}\n'));
    printUsage(showWelcome: false);
    io.exit(1);
  } catch (e, st) {
    log(red(bold('Unexpected error: $e')));
    log(red(st));
    io.exit(1);
  }

  logger = LoggerUtils.fromConfig(config);

  // Only shows up when verbose mode is enabled.
  trace(magenta('Verbose logging enabled.'));
  trace(noColor('Generated config from args: ${none(config)}'));
  trace('------------------------------------------');

  if (config.version) {
    return;
  }

  if (config.help) {
    return printUsage();
  }

  final app = CliApp(config);

  try {
    return await app.run();
  } catch (e) {
    trace('Unexpected exception occurred while running app.run().');
    log(red('Unexpected while running: ${bold(e)}'));
    io.exit(1);
  }
}

void printUsage({bool showWelcome = true}) {
  if (showWelcome) {
    log('''
${yellow(appName)} is a tool for Mac OS that uses AnyBar
to show when your Mac is thermal throttling.
''');
  }
  log('''
usage: ${bold(executableName)}
${Config.usage}''');
}
