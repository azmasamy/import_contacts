import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

enum ContactsSceenState { init, loading, loaded }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ContactsSceenState state = ContactsSceenState.init;
  List<Contact> contacts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  buildBody() {
    switch (state) {
      case ContactsSceenState.init:
        return Center(
          child: ElevatedButton(
              onPressed: () async {
                // Request contact permission
                setState(() {
                  state = ContactsSceenState.loading;
                });
                if (await FlutterContacts.requestPermission()) {
                  // Get all contacts (fully fetched)
                  contacts = await FlutterContacts.getContacts(
                      withProperties: true, withPhoto: true);
                  print(contacts);
                }
                setState(() {
                  state = ContactsSceenState.loaded;
                });
              },
              child: const Text("Import Contacts")),
        );
      case ContactsSceenState.loading:
        return const Center(child: CircularProgressIndicator());
      case ContactsSceenState.loaded:
        return SafeArea(
            child: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) => ListTile(
            leading: Text(contacts[index].id),
            title: Text(contacts[index].displayName),
            subtitle: contacts[index].phones.isNotEmpty
                ? Text(contacts[index].phones[0].number)
                : Container(),
          ),
        ));
    }
  }
}
