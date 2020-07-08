class AnyBarColor {
  const AnyBarColor._(this.value);

  final String value;

  static const white = AnyBarColor._('white');
  static const red = AnyBarColor._('red');
  static const orange = AnyBarColor._('orange');
  static const yellow = AnyBarColor._('yellow');
  static const green = AnyBarColor._('green');
  static const cyan = AnyBarColor._('cyan');
  static const blue = AnyBarColor._('blue');
  static const purple = AnyBarColor._('purple');
  static const black = AnyBarColor._('black');
  static const question = AnyBarColor._('question');
  static const exclamation = AnyBarColor._('exclamation');

  @override
  String toString() => 'AnyBarColor(value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AnyBarColor && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
