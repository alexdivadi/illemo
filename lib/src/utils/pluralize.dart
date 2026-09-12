extension Pluralize on String {
  String pluralize(int count) {
    if (count == 1) {
      return this;
    } else {
      return '${this}s';
    }
  }
}
