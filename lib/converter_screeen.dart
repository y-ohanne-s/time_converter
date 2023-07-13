import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:time_converter/helper.dart';
import 'package:time_converter/request.dart';
import 'package:time_converter/zone_data.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final initialHourController = TextEditingController();
  final initialMinuteController = TextEditingController();
  final finalHourController = TextEditingController();
  final finalMinuteController = TextEditingController();

  final firstZoneController = TextEditingController();
  final secondZoneController = TextEditingController();

  ({String fromZone, String toZone, int fromTimestamp, int toTimestamp})? timeData;

  Future<void> onConvert(ThemeData theme) async {
    final firstZone = firstZoneController.text.replaceAll(RegExp(r' '), '_');
    final secondZone = secondZoneController.text.replaceAll(RegExp(r' '), '_');

    if (firstZone.isEmpty || secondZone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 5,
          backgroundColor: theme.colorScheme.background,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          behavior: SnackBarBehavior.floating,
          content: Text("Please select a timezone", style: theme.textTheme.bodyMedium),
        ),
      );
      return;
    }

    if (initialHourController.text.isEmpty || initialMinuteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 5,
          backgroundColor: theme.colorScheme.background,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          behavior: SnackBarBehavior.floating,
          content: Text("Please enter a time", style: theme.textTheme.bodyMedium),
        ),
      );
      return;
    }

    final DateTime now = DateTime.now().copyWith(
      hour: int.parse(initialHourController.text),
      minute: int.parse(initialMinuteController.text),
    );

    try {
      print(DateTime.now());
      print(DateTime.now().millisecondsSinceEpoch);
      print(now);
      print(now.millisecondsSinceEpoch);

      final data = await ApiRequest.convertTimeZone(
        firstZone,
        secondZone,
        now.millisecondsSinceEpoch,
      );

      print(data);
      setState(() => timeData = data);
    } catch (e) {
      debugPrint("Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 5,
          backgroundColor: theme.colorScheme.background,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          behavior: SnackBarBehavior.floating,
          content: Text("Error", style: theme.textTheme.bodyMedium),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "First Location",
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(height: 5),
            AutocompleteTextField(textEditingController: firstZoneController),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TimeTextfield(
                    controller: initialHourController,
                    hintText: "hh",
                  ),
                  Text(
                    ':',
                    style: theme.textTheme.headlineSmall,
                  ),
                  TimeTextfield(
                    controller: initialMinuteController,
                    hintText: "mm",
                  ),
                ],
              ),
            ),
            Text(
              "Second Location",
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(height: 5),
            AutocompleteTextField(textEditingController: secondZoneController),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () => onConvert(theme),
                  child: Text(
                    'Convert',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            Divider(
              color: theme.colorScheme.primary.withOpacity(0.3),
              thickness: 0.5,
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: timeData != null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ConvertedDataDisplay(
                    location:
                        timeData != null ? timeData!.fromZone.replaceAll(RegExp(r'_'), " ") : "",
                    time: timeData != null
                        ? HelperFuncitons.geTimeFromTimestamp(
                            timeData!.fromTimestamp,
                          )
                        : "",
                  ),
                  ConvertedDataDisplay(
                    location:
                        timeData != null ? timeData!.toZone.replaceAll(RegExp(r'_'), " ") : "",
                    time: timeData != null
                        ? HelperFuncitons.geTimeFromTimestamp(timeData!.toTimestamp, isUtc: true)
                        : "",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConvertedDataDisplay extends StatelessWidget {
  const ConvertedDataDisplay({
    super.key,
    required this.location,
    required this.time,
  });

  final String location;
  final String time;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          location,
          style: theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          time,
          style: theme.textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w200),
        ),
      ],
    );
  }
}

class TimeTextfield extends StatelessWidget {
  const TimeTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.disabled = false,
  });

  final TextEditingController controller;
  final String hintText;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: controller,
        readOnly: disabled,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          return null;
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(2),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}

class AutocompleteTextField extends StatelessWidget {
  AutocompleteTextField({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RawAutocomplete(
      textEditingController: textEditingController,
      focusNode: focusNode,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }

        return zones.where((String option) {
          return option
              .replaceAll(RegExp(r'_'), " ")
              .replaceAll(RegExp(r'/'), "")
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      optionsViewBuilder: (context, AutocompleteOnSelected<String> onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
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
                    child: Builder(builder: (BuildContext context) {
                      final bool highlight = AutocompleteHighlightedOption.of(context) == index;
                      if (highlight) {
                        SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
                          Scrollable.ensureVisible(context, alignment: 0.5);
                        });
                      }
                      return Container(
                        color: highlight ? Theme.of(context).focusColor : null,
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          option.replaceAll(RegExp(r'_'), " "),
                          style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w100),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ),
        );
      },
      displayStringForOption: (option) => option.replaceAll(RegExp(r'_'), " "),
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter a Location',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some location';
            }
            if (!zones.contains(value)) {
              return 'Location Not Supported, please enter a valid location';
            }
            return null;
          },
        );
      },
    );
  }
}
