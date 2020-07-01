import 'package:args/args.dart';
import 'package:temptrail/src/config.dart';

extension CustomArgs on ArgParser {
  ArgParser withAllArgs() => withPort().withHelp().withVersion().withVerbose().withAnsi();

  ArgParser withPort() => this
    ..addOption(
      Config.keyPort,
      abbr: 'p',
      help: 'The port number of the AnyBar instance.'
          'For example: --rate 1738',
      valueHelp: 'PORT',
      defaultsTo: '1738',
      callback: (String value) {
        if (value != null && double.tryParse(value) == null) {
          throw FormatException('Port must be a number', value);
        }
      },
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
