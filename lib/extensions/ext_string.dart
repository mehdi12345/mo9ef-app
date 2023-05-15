extension StringValidators on String {
  meetsPasswordRequirements() {
    RegExp regEx = RegExp(r"(?=.*[a-z])(?=.*[A-Z])\w+");
    return regEx.hasMatch(this);
  }

  moneyFormat() {
    var value = this;
    if (length > 2) {
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ' ');
    }
    return value;
  }
}
