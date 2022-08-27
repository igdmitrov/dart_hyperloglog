import 'package:dart_hyperloglog/dart_hyperloglog.dart' as dart_hyperloglog;
import 'package:dart_hyperloglog/dart_standard.dart' as dart_standard;

Future<void> main(List<String> arguments) async {
  Stopwatch stopwatch = Stopwatch()..start();

  int num = 50000000;
  int duplicate = 100;

  //printResult(num, dart_standard.calculationV1(num, duplicate));
  //printResult(num, dart_standard.calculationV2(num, duplicate));
  //printResult(num, dart_standard.calculationV3(num, duplicate));
  //printResult(num, dart_hyperloglog.calculationV1(num, duplicate));
  printResult(num, await dart_hyperloglog.calculationV2(num, duplicate));

  print('Executed in ${stopwatch.elapsed}');
}

void printResult(int exactValue, int counted) {
  print('Count: $counted, error: ${(1 - exactValue / counted) * 100}');
}
