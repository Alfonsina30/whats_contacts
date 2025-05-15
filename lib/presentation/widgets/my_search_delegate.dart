import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whats_contacts/domain/model/contact_model.dart';
import 'package:whats_contacts/presentation/bloc/contact_permission/contact_permission_bloc.dart';
import 'package:whats_contacts/presentation/bloc/contact_selected/contact_selected_bloc.dart';

class MySearchDelegate extends SearchDelegate {
  final List<ContactModel> contacts;

  MySearchDelegate({required this.contacts});

  ///---- crear acciones en el appBar
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear, color: Theme.of(context).iconTheme.color))
    ];
  }

  ///---> salir de la pantalla de busqueda
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).iconTheme.color,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _customWidget(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _customWidget(context);
  }

  Widget _customWidget(BuildContext context) {
    return BlocBuilder<ContactSelectedBloc, ContactSelectedState>(
        builder: (context, state) {
      return FutureBuilder(
          future:
              context.read<ContactPermissionBloc>().requestContactPermission(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: SizedBox(height: 50, child: CircularProgressIndicator()),
              );
            }

            final searchResult = query.isEmpty
                ? snapshot.data ?? <ContactModel>[]
                : snapshot.data ??
                    []
                        .where((contact) => contact.name
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList();

            return ListView.builder(
                itemCount: searchResult.length,
                itemBuilder: (context, index) {
                  final ContactModel contact = searchResult[index];

                  return Column(children: [
                    ListTile(
                      leading: const CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.person),
                      ),
                      title: Text(contact.name),
                      subtitle: (contact.phone.isNotEmpty)
                          ? Row(
                              children: [
                                Icon(Icons.phone, size: 14),
                                SizedBox(width: 10),
                                Text(contact.phone),
                              ],
                            )
                          : null,
                      trailing: IconButton(
                          onPressed: () {
                            context
                                .read<ContactSelectedBloc>()
                                .handleContactSelected(contact);
                          },
                          icon: (state.contactSelected.any(
                                  (item) => item.name.contains(contact.name)))
                              ? Icon(
                                  Icons.check_box,
                                  color: Theme.of(context).iconTheme.color,
                                )
                              : Icon(Icons.check_box_outline_blank)),
                      onTap: () {
                        query = contact.name;
                      },
                    ),
                    const Divider()
                  ]);
                });
          });
    });
  }
}
