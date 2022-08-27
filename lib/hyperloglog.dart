import 'dart:math';

import 'package:murmurhash/murmurhash.dart';

class HyperLogLog {
  double _mapSize = 0.0;
  late final double _alphaM;
  late final int _kComplement;
  final Map<int, int> map = {};
  static const double _pow_2_32 = 4294967297;

  HyperLogLog(double stdError) {
    _mapSize = 1.04 / stdError;

    final k = (_log2(_mapSize * _mapSize)).ceil();

    _kComplement = 32 - k;
    _mapSize = pow(2, k).toDouble();

    _alphaM = _mapSize == 16
        ? 0.673
        : _mapSize == 32
            ? 0.697
            : _mapSize == 64
                ? 0.709
                : 0.7213 / (1 + 1.079 / _mapSize);

    for (int i = 0; i < _mapSize; i++) {
      map[i] = 0;
    }
  }

  double _log2(double x) {
    return log(x) / ln2;
  }

  int _getRank(int hash, int max) {
    int r = 1;
    while ((hash & 1) == 0 && r <= max) {
      ++r;
      hash >>= 1;
    }
    return r;
  }

  void add(String val) {
    int hashCode = MurmurHash.v3(val, 0);
    int j = hashCode >> _kComplement;

    map[j] = max(
        map[j] == null ? 0 : map[j] as int, _getRank(hashCode, _kComplement));
  }

  int count() {
    double c = 0;

    for (var i = 0; i < _mapSize; i++) {
      c += 1.0 / pow(2, map[i] as int);
    }

    double E = _alphaM * _mapSize * _mapSize / c;

    if (E <= (5 / 2) * _mapSize) {
      double V = 0;
      for (var i = 0; i < _mapSize; i++) {
        if (map[i] == 0) {
          V++;
        }
      }
      if (V > 0) {
        E = _mapSize * log(_mapSize / V);
      }
    } else {
      if (E > (1 / 30) * _pow_2_32) {
        E = -_pow_2_32 * log(1 - (E / _pow_2_32));
      }
    }

    return E.toInt();
  }

  void merge(HyperLogLog hyperLogLog) {
    for (var i = 0; i < _mapSize; i++) {
      map[i] =
          max(map[i] == null ? 0 : map[i] as int, hyperLogLog.map[i] as int);
    }
  }
}
