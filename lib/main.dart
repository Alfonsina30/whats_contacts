import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whats_contacts/presentation/bloc/contact_selected/contact_selected_bloc.dart';

import 'presentation/bloc/contact_permission/contact_permission_bloc.dart';
import 'domain/native/meth_channel.dart';
import 'presentation/widgets/my_search_delegate.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => ContactPermissionBloc(
            connectionWithMethChannel: ConnectionWithMethChannel()),
      ),
      BlocProvider(
        create: (context) => ContactSelectedBloc(),
      ),
    ],
    child: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepOrange),
      home: ContactsPage(),
    );
  }
}

class ContactsPage extends StatefulWidget {
  const ContactsPage({
    super.key,
  });

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    context.read<ContactPermissionBloc>().checkPermission();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      context.read<ContactPermissionBloc>().checkPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactsPermission = context.watch<ContactPermissionBloc>().state;

    final contactSelected =
        context.watch<ContactSelectedBloc>().state.contactSelected;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Whats Contacts"),
        actions: [
          IconButton(
              onPressed: () async {
                if (context.mounted) {
                  showSearch(
                    context: context,
                    delegate:
                        MySearchDelegate(contacts: contactsPermission.contacts),
                  );
                }
              },
              icon: Icon(Icons.search_rounded))
        ],
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckboxListTile(
              title: Text('Permission contact granted'),
              value: contactsPermission.isPermisionGranted,
              onChanged: (_) async {
                await context
                    .read<ContactPermissionBloc>()
                    .requestContactPermission();
              }),
          SizedBox(height: 20),
          if (contactsPermission.isPermisionGranted)
            Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.60,
                ),
                child: ListView.builder(
                    itemCount: contactSelected.length,
                    itemBuilder: (context, index) {
                      final contact = contactSelected[index];

                      return Column(children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            child: Icon(Icons.person),
                          ),
                          title: Text(contact.name),
                          subtitle: (contact.phone.isNotEmpty)
                              ? Text(contact.phone)
                              : null,
                          trailing: (contactSelected.any(
                                  (item) => item.name.contains(contact.name)))
                              ? Icon(
                                  Icons.check_box,
                                  color: Theme.of(context).primaryColor,
                                )
                              : Icon(Icons.check_box_outline_blank),
                          onTap: () {
                            context
                                .read<ContactSelectedBloc>()
                                .handleContactSelected(contact);
                          },
                        ),
                        const Divider()
                      ]);
                    })),
        ],
      )),
    );
  }
}
