// source: https://gist.github.com/kaendfinger/58313c66b851cf7082f0

memoize(Function input) {
  var cache = {};
  var capture = new _FunctionCapture((p, n) {
    var call = new _FunctionCall(p, n);
    if (cache.containsKey(call)) {
      print("Using Cache");
      return cache[call];
    } else {
      print("Placing in Cache");
      return cache[call] = Function.apply(input, p, n);
    }
  });
  return capture;
}

class _FunctionCall {
  final List<dynamic> positional;
  final Map<Symbol, dynamic> named;

  _FunctionCall(this.positional, this.named);

  int get hashCode => _hashObjects([]..addAll(positional)..addAll(named.keys)..addAll(named.values));
  bool operator ==(obj) {
    if (obj is! _FunctionCall) return false;
    var indexes = new List.generate(obj.positional.length, (i) => i);
    return indexes.every((i) => positional[i] == obj.positional[i]);
  }
}

class _FunctionCapture {
  final Function handler;

  _FunctionCapture(this.handler);

  @override
  noSuchMethod(Invocation inv) {
    print(inv);
    if (inv.isMethod && inv.memberName == #call) {
      return handler(inv.positionalArguments, inv.namedArguments);
    } else {
      return super.noSuchMethod(inv);
    }
  }
}

/* Utils */
int _hashObjects(Iterable objects) => _finish(objects.fold(0, (h, i) => _combine(h, i.hashCode)));

int _combine(int hash, int value) {
  hash = 0x1fffffff & (hash + value);
  hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
  return hash ^ (hash >> 6);
}

int _finish(int hash) {
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}
