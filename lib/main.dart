import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whats_contacts/data/data_files.dart';
import 'package:whats_contacts/presentation/presentation_files.dart';


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
