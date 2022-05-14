extension ListEx<T, E> on List<T> {
  List<E> mapAsList(E Function(T t) mapTo) {
    final List<E> result = [];

    for (var t in this) {
      result.add(mapTo(t));
    }

    return result;
  }
}
