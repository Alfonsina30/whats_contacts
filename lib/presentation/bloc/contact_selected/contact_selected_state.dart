part of 'contact_selected_bloc.dart';

class ContactSelectedState extends Equatable {
  final List<ContactModel> contactSelected;

  const ContactSelectedState({required this.contactSelected});

  ContactSelectedState copyWith({List<ContactModel>? contactSelected}) =>
      ContactSelectedState(
          contactSelected: contactSelected ?? this.contactSelected);

  @override
  List<Object?> get props => [contactSelected];
}
