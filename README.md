# autocomplete_plus
 Flutter package AutoCompletePlus


#🚧 Tests in progress...

```dart
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
```

```dart
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
```

```dart
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
              ),
```


