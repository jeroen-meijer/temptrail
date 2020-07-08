// 📦 Package imports:
import 'package:cli_util/cli_logging.dart';

// 🌎 Project imports:
import 'package:temptrail/src/config.dart';

typedef LogCallback = void Function(String);

Logger logger = Logger.standard(ansi: Ansi(true));

LogCallback get log => logger.stdout;
LogCallback get err => logger.stderr;
LogCallback get trace => logger.trace;

extension LoggerUtils on Logger {
  static Logger fromConfig(Config config) {
    final ansi = Ansi(config.ansi);
    return config.verbose ? Logger.verbose(ansi: ansi) : Logger.standard(ansi: ansi);
  }
}
