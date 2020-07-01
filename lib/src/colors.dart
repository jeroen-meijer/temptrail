import 'package:temptrail/src/logging.dart';

typedef ColorWrapper = String Function(Object value);

final noColor = _wrap(logger.ansi.noColor);
final subtle = _wrap(logger.ansi.gray);
final green = _wrap(logger.ansi.green);
final red = _wrap(logger.ansi.red);
final blue = _wrap(logger.ansi.blue);
final magenta = _wrap(logger.ansi.magenta);
final yellow = _wrap(logger.ansi.yellow);

final none = _wrap(logger.ansi.none);
final bold = _wrap(logger.ansi.bold);

ColorWrapper _wrap(String ansiModifier) => (value) => '$ansiModifier$value${logger.ansi.none}';
