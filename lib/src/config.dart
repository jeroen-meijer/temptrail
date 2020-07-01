import 'package:args/args.dart';
import 'package:meta/meta.dart';
import 'package:temptrail/src/args.dart';

@immutable
class Config {
  const Config._({
    @required this.port,
    @required this.help,
    @required this.version,
    @required this.verbose,
    @required this.ansi,
  });

  static const keyPort = 'port';
  static const keyHelp = 'help';
  static const keyVersion = 'version';
  static const keyVerbose = 'verbose';
  static const keyAnsi = 'ansi';

  final String port;
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
      port: options[keyPort],
      help: options[keyHelp],
      version: options[keyVersion],
      verbose: options[keyVerbose],
      ansi: options[keyAnsi],
    );
  }

  @override
  String toString() {
    return 'Config(port: $port, help: $help, version: $version, verbose: $verbose, ansi: $ansi)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Config &&
        other.port == port &&
        other.help == help &&
        other.version == version &&
        other.verbose == verbose &&
        other.ansi == ansi;
  }

  @override
  int get hashCode {
    return port.hashCode ^ help.hashCode ^ version.hashCode ^ verbose.hashCode ^ ansi.hashCode;
  }
}

class ArgError implements Exception {
  final String message;
  ArgError(this.message);

  @override
  String toString() => message;
}
