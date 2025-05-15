import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:whats_contacts/domain/model/contact_model.dart';
part 'contact_selected_event.dart';
part 'contact_selected_state.dart';

class ContactSelectedBloc
    extends Bloc<ContactSelectedEvent, ContactSelectedState> {
  ContactSelectedBloc() : super(ContactSelectedState(contactSelected: [])) {
    on<ContactSelected>((event, emit) {
      emit(event.newState);

      log('NEW STATE $state');
    });
  }

  void handleContactSelected(ContactModel contact) {
    final newState = <ContactModel>[...state.contactSelected];

    if (!newState.any((item) => item.name.contains(contact.name))) {
      newState.add(contact);
    } else {
      newState.removeWhere((item) => item.name == contact.name);
    }
    add(ContactSelected(newState: state.copyWith(contactSelected: newState)));
  }
}
