import 'package:flutter/material.dart';

class DynamicDropdown extends StatefulWidget {
  final List<String> defaultValues;
  final Color? borderColor;
  final String headerText;
  final Map<String, String> dynamicFields;

  const DynamicDropdown({
    Key? key,
    required this.defaultValues,
    required this.headerText,
    this.borderColor,
    required this.dynamicFields,
  }) : super(key: key);

  @override
  _DynamicDropdownState createState() => _DynamicDropdownState();
}

class _DynamicDropdownState extends State<DynamicDropdown> {
  List<DropdownButton<String>> dropdowns = [];
  int indexCounter = 0;

  @override
  void initState() {
    super.initState();
    dropdowns.add(buildDropdown(0));
  }

DropdownButton<String> buildDropdown(int index) {
  String fieldLabel = '${widget.headerText}_${index + 1}';

  return DropdownButton<String>(
    items: widget.defaultValues.map((value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    onChanged: (String? value) {
      setState(() {
        widget.dynamicFields[fieldLabel] = value!;
        print('Dropdown index: $index changed to $value'); // Print the index to the console
      });
    },
    value: widget.dynamicFields[fieldLabel],
  );
}


  void addDropdown() {
    if (dropdowns.length < 6) {
      setState(() {
        dropdowns.add(buildDropdown(dropdowns.length));
      });
    }
  }

  void removeDropdown() {
    if (dropdowns.isNotEmpty) {
      setState(() {
        dropdowns.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: addDropdown,
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: removeDropdown,
            ),
          ],
        ),
        Expanded(
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: widget.headerText,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor ?? Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < dropdowns.length; i++)
                    Row(
                      children: [
                        dropdowns[i],
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
