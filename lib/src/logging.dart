import 'package:cli_util/cli_logging.dart';
import 'package:temptrail/src/config.dart';

typedef LogCallback = void Function(String);
typedef ColorWrapper = String Function(Object value);

Logger logger = Logger.standard(ansi: Ansi(true));

LogCallback get log => logger.stdout;
LogCallback get err => logger.stderr;
LogCallback get trace => logger.trace;

extension LoggerUtils on Logger {
  static Logger fromConfig(Config config) {
    final ansi = Ansi(config.ansi);
    return config.verbose
        ? Logger.verbose(ansi: ansi)
        : Logger.standard(ansi: ansi);
  }
}

void drawDivider() => log(subtle('-----------------------'));

final noColor = _wrap(logger.ansi.noColor);
final subtle = _wrap(logger.ansi.gray);
final green = _wrap(logger.ansi.green);
final red = _wrap(logger.ansi.red);
final blue = _wrap(logger.ansi.blue);
final magenta = _wrap(logger.ansi.magenta);
final yellow = _wrap(logger.ansi.yellow);

final none = _wrap(logger.ansi.none);
final bold = _wrap(logger.ansi.bold);

ColorWrapper _wrap(String ansiModifier) =>
    (value) => '$ansiModifier$value${logger.ansi.none}';
