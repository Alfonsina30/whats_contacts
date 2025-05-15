class ContactModel {
  final String name;
  final String phone;

  ContactModel({this.name = '', required this.phone});

  @override
  String toString() {
    return 'NAME: $name PHONE: $phone';
  }
}
