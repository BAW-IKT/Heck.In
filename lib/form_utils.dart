import 'package:flutter/material.dart';

Column buildFormFieldGrid(List<Map<String, dynamic>> inputFields,
    String sectionToBuild, Function setState,
    {columns = 3, Color? borderColor}) {
  List<Widget> rows = [];
  List<Widget> rowChildren = [];
  for (var field in inputFields) {
    if (field['section'] != sectionToBuild) {
      continue;
    }
    if (field['type'] == 'text') {
      rowChildren.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: TextFormField(
              controller: field['controller'],
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: borderColor != null ? BorderSide(color: borderColor) : const BorderSide(),
                ),
                labelText: field['label'],
              ),
              keyboardType: TextInputType.text,
              validator: field['validator'],
            ),
          ),
        ),
      );
    } else if (field['type'] == 'dropdown') {
      var dropdownItems =
          field['values'].map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList();
      rowChildren.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: DropdownButtonFormField(
              value: field['selectedValue'],
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: borderColor != null ? BorderSide(color: borderColor) : const BorderSide(),
                ),
                labelText: field['label'],
              ),
              items: dropdownItems,
              onChanged: (value) {
                setState(() {
                  field['selectedValue'] = value;
                });
              },
              validator: field['validator'],
            ),
          ),
        ),
      );
    } else if (field['type'] == 'number') {
      rowChildren.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: TextFormField(
              controller: field['controller'],
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: borderColor != null ? BorderSide(color: borderColor) : const BorderSide(),
                ),
                labelText: field['label'],
              ),
              keyboardType: TextInputType.number,
              validator: field['validator'],
            ),
          ),
        ),
      );
    }
    if (rowChildren.length == columns) {
      rows.add(Row(children: rowChildren));
      rowChildren = [];
    }
  }
  if (rowChildren.isNotEmpty) {
    rows.add(Row(children: rowChildren));
  }
  return Column(children: rows);
  // return rows;
}

Center createHeader(String headerText, {double fontSize = 24}) {
  return Center(
      child: Text(
    headerText,
    style: TextStyle(fontSize: fontSize),
  ));
}

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationDialog({
    Key? key,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Action'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
