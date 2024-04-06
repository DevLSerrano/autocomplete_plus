library autocomplete_plus;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum TypeAutoComplete { fade, floating, both }

class AutoCompletePlus<T extends Object> extends StatefulWidget {
  final FutureOr<Iterable<T>> Function(
    TextEditingValue textEditingValue,
  ) optionsBuilder;
  final InputDecoration? fieldDecoration;
  final BoxDecoration? optionsBoxDecorations;
  final TextFormField Function(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    void Function() onFieldSubmitted,
    InputDecoration? decoration,
    int? maxLines,
    int? minLines,
  )? fieldViewBuilder;
  final TextStyle fadeTextStyle;
  final Widget Function(
    BuildContext context,
    T option,
  )? optionsViewBuilder;
  final TypeAutoComplete typeAutoComplete;
  final String Function(T) displayStringForOption;
  final void Function(T option)? onSelected;
  final double optionsMaxHeight;
  final OptionsViewOpenDirection optionsViewOpenDirection;
  final int? maxLines;
  final int? minLines;

  const AutoCompletePlus.fade({
    super.key,
    required this.optionsBuilder,
    this.fieldDecoration,
    this.fieldViewBuilder,
    required this.fadeTextStyle,
    this.onSelected,
    this.optionsMaxHeight = 200,
    this.maxLines = 1,
    this.minLines,
  })  : typeAutoComplete = TypeAutoComplete.fade,
        optionsViewBuilder = null,
        optionsBoxDecorations = null,
        optionsViewOpenDirection = OptionsViewOpenDirection.down,
        displayStringForOption = AutoCompletePlus.defaultStringForOption;

  const AutoCompletePlus.floating({
    super.key,
    required this.optionsBuilder,
    this.fieldDecoration,
    this.fieldViewBuilder,
    this.optionsViewBuilder,
    this.onSelected,
    this.optionsBoxDecorations,
    this.displayStringForOption = AutoCompletePlus.defaultStringForOption,
    this.optionsMaxHeight = 200,
    this.optionsViewOpenDirection = OptionsViewOpenDirection.down,
    this.maxLines = 1,
    this.minLines,
  })  : typeAutoComplete = TypeAutoComplete.floating,
        fadeTextStyle = const TextStyle(
          color: Colors.transparent,
        );

  const AutoCompletePlus.fadeAndFloating({
    super.key,
    required this.optionsBuilder,
    this.fieldDecoration,
    this.fieldViewBuilder,
    required this.fadeTextStyle,
    this.optionsViewBuilder,
    this.onSelected,
    this.optionsBoxDecorations,
    this.displayStringForOption = AutoCompletePlus.defaultStringForOption,
    this.optionsMaxHeight = 200,
    this.optionsViewOpenDirection = OptionsViewOpenDirection.down,
    this.maxLines = 1,
    this.minLines,
  }) : typeAutoComplete = TypeAutoComplete.both;

  static String defaultStringForOption(Object value) => value.toString();

  @override
  State<AutoCompletePlus<T>> createState() => _AutoCompletePlusState<T>();
}

class _AutoCompletePlusState<T extends Object>
    extends State<AutoCompletePlus<T>> {
  final _rawKey = GlobalKey();
  final _fadeController = TextEditingController();
  final _mainController = TextEditingController();
  final _mainFocusNode = FocusNode();

  void _listenerClearFade() => _fadeController.clear();

  @override
  void initState() {
    _mainFocusNode.addListener(_listenerClearFade);
    super.initState();
  }

  @override
  void dispose() {
    _mainFocusNode.removeListener(_listenerClearFade);
    _fadeController.dispose();
    _mainFocusNode.dispose();
    _mainController.dispose();
    _rawKey.currentState?.dispose();
    super.dispose();
  }

  TextFormField _defaultFieldViewBuilder(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    void Function() onFieldSubmitted,
    InputDecoration? decoration,
    int? maxLines,
    int? minLines,
  ) =>
      TextFormField(
        controller: controller,
        focusNode: focusNode,
        onFieldSubmitted: (value) => onFieldSubmitted(),
        decoration: decoration,
        maxLines: maxLines,
        minLines: minLines,
      );

  @override
  Widget build(BuildContext context) {
    return RawFadeAutoComplete<T>(
      rawKey: _rawKey,
      decoration: widget.fieldDecoration,
      fadeController: _fadeController,
      fieldViewBuilder: widget.fieldViewBuilder ?? _defaultFieldViewBuilder,
      optionsBuilder: widget.optionsBuilder,
      fadeTextStyle: widget.fadeTextStyle,
      typeAutoComplete: widget.typeAutoComplete,
      displayStringForOption: (Object obj) =>
          widget.displayStringForOption(obj as T),
      optionsViewBuilder: widget.optionsViewBuilder,
      optionsMaxHeight: widget.optionsMaxHeight,
      textEditingController: _mainController,
      focusNode: _mainFocusNode,
      onSelected: (option) async {
        _fadeController.text = widget.displayStringForOption(option as T);
        _mainController.text = widget.displayStringForOption(option);
        widget.onSelected?.call(option);
      },
      optionsBoxDecorations: widget.optionsBoxDecorations,
      optionsViewOpenDirection: widget.optionsViewOpenDirection,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
    );
  }
}

class RawFadeAutoComplete<T extends Object> extends RawAutocomplete {
  RawFadeAutoComplete({
    super.key,
    required GlobalKey rawKey,
    BoxDecoration? optionsBoxDecorations,
    required FutureOr<Iterable<T>> Function(
      TextEditingValue textEditingValue,
    ) optionsBuilder,
    required InputDecoration? decoration,
    required TextFormField Function(
      BuildContext context,
      TextEditingController controller,
      FocusNode focusNode,
      void Function() onFieldSubmitted,
      InputDecoration? decoration,
      int? maxLines,
      int? minLines,
    ) fieldViewBuilder,
    Widget Function(
      BuildContext context,
      T option,
    )? optionsViewBuilder,
    int? maxLines = 1,
    int? minLines,
    required TextStyle fadeTextStyle,
    required TextEditingController fadeController,
    required TypeAutoComplete typeAutoComplete,
    required super.displayStringForOption,
    required super.onSelected,
    required double optionsMaxHeight,
    required super.textEditingController,
    required super.focusNode,
    required super.optionsViewOpenDirection,
  }) : super(
          optionsBuilder: (textEditingValue) async {
            final optionResult = await optionsBuilder(textEditingValue);
            if (optionResult.isEmpty) {
              fadeController.clear();
            } else {
              fadeController.text = displayStringForOption(optionResult.first);
            }

            return optionResult;
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return Stack(
              key: rawKey,
              children: [
                Offstage(
                  offstage: typeAutoComplete == TypeAutoComplete.floating,
                  child: TextFormField(
                    controller: fadeController,
                    decoration: decoration,
                    readOnly: true,
                    style: fadeTextStyle,
                    maxLines: maxLines,
                    minLines: minLines,
                  ),
                ),
                fieldViewBuilder(
                  context,
                  controller,
                  focusNode,
                  () {
                    controller.text = fadeController.text;
                    onFieldSubmitted();
                  },
                  decoration,
                  maxLines,
                  minLines,
                ),
              ],
            );
          },
          optionsViewBuilder: (context, onSelect, options) {
            Future.delayed(Duration.zero, () {
              fadeController.text = displayStringForOption(options.first);
            });

            return switch (typeAutoComplete) {
              TypeAutoComplete.fade => const SizedBox.shrink(),
              _ => AutoCompletePlusOptions(
                  displayStringForOption: displayStringForOption,
                  onSelected: onSelect,
                  options: options,
                  maxOptionsHeight: optionsMaxHeight,
                  fadeController: fadeController,
                  optionsBoxDecorations: optionsBoxDecorations,
                  rawKey: rawKey,
                  optionsViewOpenDirection: optionsViewOpenDirection,
                  optionsViewBuilder: optionsViewBuilder as Widget Function(
                      BuildContext, Object)?,
                ),
            };
          },
        );
}

class AutoCompletePlusOptions<T extends Object> extends StatelessWidget {
  const AutoCompletePlusOptions({
    super.key,
    required this.displayStringForOption,
    required this.onSelected,
    required this.options,
    required this.maxOptionsHeight,
    required this.fadeController,
    required this.rawKey,
    required this.optionsViewOpenDirection,
    this.optionsBoxDecorations,
    this.optionsViewBuilder,
  });
  final BoxDecoration? optionsBoxDecorations;
  final GlobalKey rawKey;
  final OptionsViewOpenDirection optionsViewOpenDirection;
  final TextEditingController fadeController;

  final AutocompleteOptionToString<T> displayStringForOption;

  final AutocompleteOnSelected<T> onSelected;

  final Iterable<T> options;
  final double maxOptionsHeight;
  final Widget Function(
    BuildContext context,
    T option,
  )? optionsViewBuilder;

  @override
  Widget build(BuildContext context) {
    final rawBox = rawKey.currentContext!.findRenderObject() as RenderBox;
    final rawWidth = rawBox.size.width;
    return Align(
      alignment: switch (optionsViewOpenDirection) {
        OptionsViewOpenDirection.up => Alignment.bottomLeft,
        OptionsViewOpenDirection.down => Alignment.topLeft,
      },
      child: Material(
        elevation: 4.0,
        child: DecoratedBox(
          decoration: optionsBoxDecorations ?? const BoxDecoration(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxOptionsHeight,
              maxWidth: rawWidth,
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                final option = options.elementAt(index);
                return InkWell(
                  onTap: () {
                    onSelected(option);
                  },
                  child: Builder(
                    builder: (BuildContext context) {
                      final bool highlight =
                          AutocompleteHighlightedOption.of(context) == index;
                      if (highlight) {
                        SchedulerBinding.instance.addPostFrameCallback(
                            (Duration timeStamp) {
                          Scrollable.ensureVisible(context, alignment: 0.5);
                          fadeController.text = displayStringForOption(option);
                        }, debugLabel: 'AutoCompletePlusOptions.ensureVisible');
                      }
                      return optionsViewBuilder?.call(context, option) ??
                          Container(
                            color:
                                highlight ? Theme.of(context).focusColor : null,
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              displayStringForOption(option),
                            ),
                          );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
