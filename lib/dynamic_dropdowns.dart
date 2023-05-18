import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicDropdowns extends StatefulWidget {
  final List<String> defValues;
  final String headerText;
  final Color borderColor;
  final Function(String, String) onChanged;

  const DynamicDropdowns({
    super.key,
    required this.defValues,
    required this.headerText,
    required this.borderColor,
    required this.onChanged,
  });

  @override
  DynamicDropdownsState createState() => DynamicDropdownsState();
}

class DynamicDropdownsState extends State<DynamicDropdowns> {
  List<String> selectedValues = [];
  int dropdownCount = 0;

  @override
  void initState() {
    super.initState();
    buildInitialDropdowns();
  }

  void rebuild() {
    selectedValues = [];
    dropdownCount = 0;
    buildInitialDropdowns();
    setState(() {});
  }

  void buildInitialDropdowns() async {
    // check if previous values exist in storage
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // get matching keys based on header text, e.g. "Fredl_"
    List<String> matchingKeys = prefs
        .getKeys()
        .where((key) => key.startsWith('${widget.headerText}_'))
        .toList();

    // if matching keys exist, iterate and add values to selectedValues
    if (matchingKeys.isNotEmpty) {
      for (String key in matchingKeys) {
        dropdownCount++;
        selectedValues.add(prefs.get(key).toString());
      }
    } else {
      // otherwise, build one widget as default
      dropdownCount++;
      selectedValues.add(widget.defValues[0]);
    }
  }

  void addDropdown() {
    if (dropdownCount < 6) {
      setState(() {
        dropdownCount++;
        selectedValues.add(widget.defValues[0]);
      });
    }
  }

  void removeDropdown() {
    if (dropdownCount > 0) {
      setState(() {
        dropdownCount--;
        selectedValues.removeLast();
        String dropdownKey = '${widget.headerText}_${dropdownCount + 1}';
        widget.onChanged(dropdownKey, "");
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
                    child: DropdownButton<String>(
                      value: selectedValues[index],
                      onChanged: (newValue) {
                        setState(() {
                          selectedValues[index] = newValue!;
                          // hand over parameters to parent
                          String dropdownKey =
                              '${widget.headerText}_${index + 1}';
                          widget.onChanged(dropdownKey, newValue);
                        });
                      },
                      items: widget.defValues
                          .map((value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
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
