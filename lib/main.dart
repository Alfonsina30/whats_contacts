import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upgrader/upgrader.dart';
import 'package:whats_contacts/presentation/bloc/contact_selected/contact_selected_bloc.dart';

import 'presentation/bloc/contact_permission/contact_permission_bloc.dart';
import 'domain/native/meth_channel.dart';
import 'presentation/widgets/my_search_delegate.dart';

//TODO: CREAR ARCHIVOS DE BARRIL
//TODO: ADDED NATIVE CODE FOR REQUEST PERMISSION

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepOrange,
        iconTheme: IconThemeData(color: Colors.deepOrange.shade400),
      ),
      home: UpgradeAlert(
          showIgnore: false,
          showLater: false,
          upgrader: Upgrader(
           // debugDisplayAlways: true,
            minAppVersion: "0.2.0",
            //debugLogging: true,

            // messages: MySpanishMessages()
            messages: UpgraderMessages(code: "es"),
            /*
              storeController: UpgraderStoreController(
                onAndroid: () => UpgraderAppStore(),
              )
              */
          ),
          child: ContactsPage()),
    );
  }
}
///--- Esta clase ayuda a cambiar el texto que se muestra en el showdialog
class MySpanishMessages extends UpgraderMessages {
  /// Override the message function to provide custom language localization.
  @override
  String? message(UpgraderMessage messageKey) {
    if (languageCode == 'es') {
      switch (messageKey) {
        case UpgraderMessage.body:
          return 'Una version de {{appName}} esta disponible!';
        case UpgraderMessage.buttonTitleIgnore:
          return 'es Ignore';
        case UpgraderMessage.buttonTitleLater:
          return 'es Later';
        case UpgraderMessage.buttonTitleUpdate:
          return 'es Update Now';
        case UpgraderMessage.prompt:
          return 'es Want to update?';
        case UpgraderMessage.releaseNotes:
          return 'es Release Notes';
        case UpgraderMessage.title:
          return 'Actualizar el app?';
      }
    }
    // Messages that are not provided above can still use the default values.
    return super.message(messageKey);
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
