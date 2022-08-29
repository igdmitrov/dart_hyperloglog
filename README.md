## HyperLogLog [HLL] algoritm

HyperLogLog is an algorithm for the count-distinct problem, approximating the number of distinct elements in a multiset. Calculating the exact cardinality of a multiset requires an amount of memory proportional to the cardinality, which is impractical for very large data sets. Probabilistic cardinality estimators, such as the HyperLogLog algorithm, use significantly less memory than this, at the cost of obtaining only an approximation of the cardinality. The HyperLogLog algorithm is able to estimate cardinalities of > 109 with a typical accuracy (standard error) of 2%, using 1.5 kB of memory. HyperLogLog is an extension of the earlier LogLog algorithm, itself deriving from the 1984 Flajolet–Martin algorithm.

### Create a new console application on Dart:
```
dart create -t console myapp
```

### Video on YouTube:
[![My video](https://img.youtube.com/vi/9OENQNAoxEM/0.jpg)](https://youtu.be/9OENQNAoxEM)
