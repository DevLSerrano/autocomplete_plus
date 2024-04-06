import 'package:autocomplete_plus/autocomplete_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(),
    );
  }
}

class UserModel {
  final String name;

  UserModel(this.name);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final _users = <UserModel>[
    UserModel('leonardo'),
    UserModel('leonardo Serrano'),
    UserModel('flutter'),
    UserModel('framework'),
    UserModel('dart'),
  ];

  final _words = [
    'framework',
    'leonardo serrano',
    'flutter',
    'dart',
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('autocomplete_plus'),
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Text('Fade and Floating (UserModel)'),
              const SizedBox(
                height: 16,
              ),
              AutoCompletePlus<UserModel>.fadeAndFloating(
                optionsBuilder: (textEditingValue) =>
                    textEditingValue.text.isEmpty
                        ? []
                        : _users.where(
                            (element) =>
                                element.name.startsWith(textEditingValue.text),
                          ),
                onSelected: (option) {
                  print('Selected: ${option.name}');
                },
                fieldDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                displayStringForOption: (option) => option.name,
                fadeTextStyle: const TextStyle(
                  color: Colors.grey,
                ),
                fieldViewBuilder: (
                  context,
                  controller,
                  focusNode,
                  onFieldSubmitted,
                  decoration,
                  maxLine,
                  minLine,
                ) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    onFieldSubmitted: (value) => onFieldSubmitted(),
                    decoration: decoration,
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              const Divider(),
              const Text('Floating (String)'),
              const SizedBox(
                height: 16,
              ),
              AutoCompletePlus<String>.floating(
                optionsBuilder: (textEditingValue) =>
                    textEditingValue.text.isEmpty
                        ? []
                        : _words.where(
                            (element) =>
                                element.startsWith(textEditingValue.text),
                          ),
                fieldDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Divider(),
              const Text('Fade (String)'),
              const SizedBox(
                height: 16,
              ),
              AutoCompletePlus<String>.fade(
                optionsBuilder: (textEditingValue) =>
                    textEditingValue.text.isEmpty
                        ? []
                        : _words.where(
                            (element) =>
                                element.startsWith(textEditingValue.text),
                          ),
                fieldDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                fadeTextStyle: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Divider(),
              const Text('Fade and Floating Personalized (UserModel)'),
              const SizedBox(
                height: 16,
              ),
              AutoCompletePlus<UserModel>.fadeAndFloating(
                optionsBuilder: (textEditingValue) =>
                    textEditingValue.text.isEmpty
                        ? []
                        : _users.where(
                            (element) =>
                                element.name.startsWith(textEditingValue.text),
                          ),
                onSelected: (option) {
                  print('Selected: ${option.name}');
                },
                fieldDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                optionsBoxDecorations: BoxDecoration(
                  border: Border.all(),
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                displayStringForOption: (option) => option.name,
                fadeTextStyle: const TextStyle(
                  color: Colors.grey,
                ),
                optionsViewOpenDirection: OptionsViewOpenDirection.up,
                fieldViewBuilder: (
                  context,
                  controller,
                  focusNode,
                  onFieldSubmitted,
                  decoration,
                  maxLine,
                  minLine,
                ) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    onFieldSubmitted: (value) => onFieldSubmitted(),
                    decoration: decoration,
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              const Divider(),
              const Text('Fade Big (String) BETA - do not use!'),
              const SizedBox(
                height: 16,
              ),
              AutoCompletePlus<String>.fade(
                optionsBuilder: (textEditingValue) =>
                    textEditingValue.text.isEmpty
                        ? []
                        : _words.where(
                            (element) =>
                                element.startsWith(textEditingValue.text),
                          ),
                fieldDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                fadeTextStyle: const TextStyle(
                  color: Colors.grey,
                ),
                maxLines: 10,
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
