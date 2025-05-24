import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whats_contacts/presentation/bloc/contact_permission/contact_permission_bloc.dart';
import 'package:whats_contacts/presentation/bloc/contact_selected/contact_selected_bloc.dart';
import 'package:whats_contacts/presentation/widgets/my_search_delegate.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
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
        title: const Text(
          "Whats Contacts",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepOrange.shade400,
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
              icon: Icon(
                Icons.perm_contact_calendar_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckboxListTile(
              title: Text(
                'Permission contact granted',
                style: TextStyle(color: Colors.grey.shade800),
              ),
              value: contactsPermission.isPermisionGranted,
              activeColor: Colors.deepOrange.shade400,
              onChanged: (_) async {
                await context
                    .read<ContactPermissionBloc>()
                    .requestContactPermission();
              }),
          Spacer(),
          if (contactsPermission.isPermisionGranted &&
              contactSelected.isNotEmpty)
            Column(
              children: [
                Text(
                  'Contact selected',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                SizedBox(height: 20),
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
                                      .deleteContactSelected(contact);
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            ),
                            const Divider()
                          ]);
                        })),
              ],
            )
          else
            Text(
              'Dont have contacts selected',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          Spacer(),
        ],
      ),
    );
  }
}
