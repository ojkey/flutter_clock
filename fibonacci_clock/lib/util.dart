/// Function which returns number from Fibonacci sequence.
/// step should have value from [0-7]
double fib(int step) {
  // Pre-validation
  assert(step >= 0 && step <= 7);
  // Fibonacci number by step(index) in sequence
  return _preparedSequence[step];
}

// Prepared sequence in order to reduce same multiple calculations
final _preparedSequence = _fibonacciSequence();

// Creates short list (8 items) with numbers of Fibonacci sequence.
Map<int, double> _fibonacciSequence() {
  final fib = {0: 1.0, 1: 2.0};
  for (var i = 2; i < 8; i++) {
    fib[i] = fib[i - 1] + fib[i - 2];
  }
  return fib;
}
