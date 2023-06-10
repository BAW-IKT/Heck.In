import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicDropdowns extends StatefulWidget {
  final List<String> values;
  final String headerText;
  final String originalHeader;
  final Color borderColor;
  final Function(String, String) onChanged;
  final List<String> originalValues;
  final int minDropdownCount;
  final int maxDropdownCount;

  const DynamicDropdowns({
    Key? key,
    required this.values,
    required this.headerText,
    required this.originalHeader,
    required this.borderColor,
    required this.onChanged,
    required this.originalValues,
    this.minDropdownCount = 0,
    this.maxDropdownCount = 6,
  }) : super(key: key);

  @override
  DynamicDropdownsState createState() => DynamicDropdownsState();
}

class DynamicDropdownsState extends State<DynamicDropdowns> {
  List<String> selectedValues = [];
  List<String> selectedLocaleValues = [];
  int dropdownCount = 0;

  @override
  void initState() {
    super.initState();
    buildInitialDropdowns();
  }

  void rebuild() {
    selectedValues = [];
    selectedLocaleValues = [];
    dropdownCount = 0;
    buildInitialDropdowns();
    setState(() {});
  }

  Future<void> buildInitialDropdowns() async {
    // check if previous values exist in storage
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // get matching keys based on header text, e.g. "Fredl_"
    List<String> matchingKeys = prefs
        .getKeys()
        .where((key) => key.startsWith('${widget.originalHeader}_'))
        .toList();

    // if matching keys exist, iterate and add values to selectedValues
    if (matchingKeys.isNotEmpty) {
      for (String key in matchingKeys) {
        dropdownCount++;
        String storedValue = prefs.get(key).toString();
        int storedValueIndex = widget.originalValues.indexOf(storedValue);
        selectedValues.add(storedValue);
        selectedLocaleValues.add(widget.values[storedValueIndex]);
      }
    } else {
      // otherwise, build minDropdownCount amount of widgets as default
      dropdownCount++;
      selectedValues.add(widget.values[0]);
      selectedLocaleValues.add(widget.values[0]);
    }
  }

  void addDropdown() {
    if (dropdownCount < widget.maxDropdownCount) {
      setState(() {
        dropdownCount++;
        selectedValues.add(widget.values[0]);
        selectedLocaleValues.add(widget.values[0]);
        String dropdownKey = '${widget.headerText}_$dropdownCount';
        widget.onChanged(dropdownKey, "ADD");
      });
    }
  }

  void removeDropdown() {
    if (dropdownCount > widget.minDropdownCount) {
      setState(() {
        dropdownCount--;
        selectedValues.removeLast();
        selectedLocaleValues.removeLast();
        String dropdownKey = '${widget.headerText}_${dropdownCount + 1}';
        widget.onChanged(dropdownKey, "REMOVE");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: widget.borderColor),
              onPressed: addDropdown,
            ),
            IconButton(
              icon:
                  Icon(Icons.remove_circle_outline, color: widget.borderColor),
              onPressed: removeDropdown,
            ),
          ],
        ),
        Expanded(
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: widget.headerText,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor,
                ),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  dropdownCount,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Text(
                          '#${index + 1}',
                          style: TextStyle(
                            color: widget.borderColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        DropdownButton<String>(
                          value: selectedLocaleValues[index],
                          onChanged: (newValue) {
                            setState(() {
                              selectedLocaleValues[index] = newValue!;
                              // hand over parameters to parent
                              String dropdownKey =
                                  '${widget.headerText}_${index + 1}';
                              widget.onChanged(dropdownKey, newValue);
                            });
                          },
                          items: widget.values
                              .map(
                                (value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
