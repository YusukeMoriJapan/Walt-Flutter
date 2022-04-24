enum Enum { enum1, enum2 }

extension EnumEx on Enum {
  String get name {
    switch (this) {
      case Enum.enum1:
        return 'value1';
      case Enum.enum2:
        return 'value2';
    }
  }
}