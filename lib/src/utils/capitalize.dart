extension CapitalizableString on String {
  String capitalize() =>
      length > 0 ? "${this[0].toUpperCase()}${substring(1).toLowerCase()}" : toUpperCase();
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(RegExp(r'(?<=\s)|(?<=-)'))
      .map((str) => str.capitalize())
      .join('');
}
