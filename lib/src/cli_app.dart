import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'package:temptrail/src/colors.dart';
import 'package:temptrail/src/config.dart';
import 'package:temptrail/src/logging.dart';
import 'package:temptrail/src/utils.dart';

@immutable
class CliApp {
  const CliApp(this.config);

  final Config config;

  Future<void> run() async {}

  @override
  String toString() => 'CliApp(config: $config)';
}
