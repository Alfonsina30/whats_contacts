import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:whats_contacts/presentation/bloc/contact_selected/contact_selected_bloc.dart';

import 'presentation/bloc/contact_permission/contact_permission_bloc.dart';
import 'domain/native/meth_channel.dart';
import 'presentation/pages/my_home_page.dart';

//TODO: CREAR ARCHIVOS DE BARRIL

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ContactPermissionBloc(
              connectionWithMethChannel: ConnectionWithMethChannel()),
        ),
        BlocProvider(
          create: (context) => ContactSelectedBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepOrange,
          iconTheme: IconThemeData(color: Colors.deepOrange.shade400),
        ),
        home: MyHomePage(),
      ),
    );
  }
}
