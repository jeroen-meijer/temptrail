// 📦 Package imports:
import 'package:args/args.dart';
import 'package:meta/meta.dart';

// 🌎 Project imports:
import 'package:temptrail/src/args.dart';

@immutable
class Config {
  const Config._({
    @required this.port,
    @required this.pollingRate,
    @required this.exitOnError,
    @required this.help,
    @required this.version,
    @required this.verbose,
    @required this.ansi,
  });

  static const keyPort = 'port';
  static const keyPollingRate = 'polling-rate';
  static const keyExitOnError = 'exit-on-error';
  static const keyHelp = 'help';
  static const keyVersion = 'version';
  static const keyVerbose = 'verbose';
  static const keyAnsi = 'ansi';

  final int port;
  final int pollingRate;
  final bool exitOnError;
  final bool help;
  final bool version;
  final bool verbose;
  final bool ansi;

  static final _argParser = ArgParser().withAllArgs();

  static String get usage => _argParser.usage;

  static Config fromArgs(List<String> args) {
    ArgResults options;

    try {
      options = _argParser.parse(args);
    } on FormatException catch (e) {
      throw ArgError(e.message);
    }

    return Config._(
      port: int.parse(options[keyPort]),
      pollingRate: int.parse(options[keyPollingRate]),
      exitOnError: options[keyExitOnError],
      help: options[keyHelp],
      version: options[keyVersion],
      verbose: options[keyVerbose],
      ansi: options[keyAnsi],
    );
  }

  @override
  String toString() {
    return 'Config('
        'port: $port, '
        'pollingRate: $pollingRate, '
        'exitOnError: $exitOnError, '
        'help: $help, '
        'version: $version, '
        'verbose: $verbose, '
        'ansi: $ansi'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Config &&
        other.port == port &&
        other.pollingRate == pollingRate &&
        other.exitOnError == exitOnError &&
        other.help == help &&
        other.version == version &&
        other.verbose == verbose &&
        other.ansi == ansi;
  }

  @override
  int get hashCode {
    return port.hashCode ^
        pollingRate.hashCode ^
        exitOnError.hashCode ^
        help.hashCode ^
        version.hashCode ^
        verbose.hashCode ^
        ansi.hashCode;
  }
}

class ArgError implements Exception {
  final String message;
  ArgError(this.message);

  @override
  String toString() => message;
}
