class Pair<T> {
  final T x0;
  final T x1;

  Pair(this.x0, this.x1);

  @override
  String toString() {
    return '[$x0,$x1]';
  }
}

class Pair2<S, T> {
  final S s;
  final T t;

  Pair2(this.s, this.t);

  @override
  String toString() {
    return 'Pair2{s: $s, t: $t}';
  }
}

///可变的
class Mutable<T> {
  T value;

  Mutable(this.value);

  @override
  String toString() {
    return 'Mutable{value: $value}';
  }
}
