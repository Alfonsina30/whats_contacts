class Contact {
  final String name;
  final String phone;

  Contact({this.name = '', required this.phone});

  @override
  String toString() {
    return 'NAME: $name PHONE: $phone';
  }
}
