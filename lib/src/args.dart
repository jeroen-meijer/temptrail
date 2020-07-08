// 📦 Package imports:
import 'package:args/args.dart';

// 🌎 Project imports:
import 'package:temptrail/src/config.dart';

extension CustomArgs on ArgParser {
  ArgParser withAllArgs() => withPort()
      .withPollingRate()
      .withExitOnError()
      .withHelp()
      .withVersion()
      .withVerbose()
      .withAnsi();

  ArgParser withPort() => this
    ..addOption(
      Config.keyPort,
      abbr: 'p',
      help: 'The port number of the AnyBar instance.\n'
          'For example: --port 1738',
      valueHelp: 'PORT',
      defaultsTo: '1738',
      callback: (String value) {
        if (value != null && int.tryParse(value) == null) {
          throw FormatException(
            'Port must be a whole number (integer)',
            value,
          );
        }
      },
    );

  ArgParser withPollingRate() => this
    ..addOption(
      Config.keyPollingRate,
      abbr: 'r',
      help: 'The amount of time in milliseconds to wait between refreshing.\n'
          'If provided, the program will wait for that amount of milliseconds\n'
          'every time before fetching new temperature data and updating the\n'
          'AnyBar instance.\n'
          'For example: --polling-rate 500',
      valueHelp: 'POLLING RATE IN MS',
      defaultsTo: '1000',
      callback: (String value) {
        if (int.tryParse(value) == null) {
          throw FormatException(
            'Polling rate must be a whole number (integer)',
            value,
          );
        }
      },
    );

  ArgParser withExitOnError() => this
    ..addFlag(
      Config.keyExitOnError,
      abbr: 'e',
      help: 'Exit the program when an error occurs.\n'
          'For example, if the AnyBar instance could not \n'
          'be found or updated.',
      negatable: false,
    );

  ArgParser withHelp() => this
    ..addFlag(
      Config.keyHelp,
      abbr: 'h',
      help: 'Display this help menu.',
      negatable: false,
    );

  ArgParser withVersion() => this
    ..addFlag(
      Config.keyVersion,
      help: 'Display the version for temptrail.',
      negatable: false,
    );

  ArgParser withVerbose() => this
    ..addFlag(
      Config.keyVerbose,
      abbr: 'v',
      help: 'Enable verbose logging.',
      negatable: false,
    );

  ArgParser withAnsi() => this
    ..addFlag(
      Config.keyAnsi,
      abbr: 'a',
      help: 'Enable or disable ANSI logging.',
      negatable: true,
      defaultsTo: true,
    );
}
