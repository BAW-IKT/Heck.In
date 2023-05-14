import 'package:auto_size_text/auto_size_text.dart';
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
      rowChildren.add(_createTextInput(field, borderColor: borderColor));
    } else if (field['type'] == 'dropdown') {
      rowChildren
          .add(_createDropdownInput(field, setState, borderColor: borderColor));
    } else if (field['type'] == 'number') {
      rowChildren.add(_createNumberInput(field, borderColor: borderColor));
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

int determineRequiredColumns(var mediaQueryData) {
  final screenWidth = mediaQueryData.size.width;
  int columns = 2;
  if (screenWidth > 960) {
    columns = 6;
  } else if (screenWidth > 840) {
    columns = 5;
  } else if (screenWidth > 720) {
    columns = 4;
  } else if (screenWidth > 600) {
    columns = 3;
  }
  return columns;
}

Expanded _createTextInput(var field, {Color? borderColor}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: TextFormField(
        controller: field['controller'],
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: borderColor != null
                ? BorderSide(color: borderColor)
                : const BorderSide(),
          ),
          labelText: field['label'],
        ),
        keyboardType: TextInputType.text,
        validator: field['validator'],
      ),
    ),
  );
}

Expanded _createNumberInput(var field, {Color? borderColor}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: TextFormField(
        controller: field['controller'],
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: borderColor != null
                ? BorderSide(color: borderColor)
                : const BorderSide(),
          ),
          labelText: field['label'],
        ),
        keyboardType: TextInputType.number,
        validator: field['validator'],
      ),
    ),
  );
}

Expanded _createDropdownInput(var field, Function setState,
    {Color? borderColor}) {
  var dropdownItems = field['values'].map<DropdownMenuItem<String>>((value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value,
        style: TextStyle(
          fontSize: value.length > 16 ? 10 : 12,
        ),
      ),
    );
  }).toList();
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: DropdownButtonFormField(
        value: field['selectedValue'],
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: borderColor != null
                ? BorderSide(color: borderColor)
                : const BorderSide(),
          ),
          labelText: field['label'],
          labelStyle: TextStyle(
            fontSize: field['label'].length > 24 ? 14 : 16,
          ),
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
  );
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

// class DropdownButtonExample extends StatefulWidget {
//   final Map<String, dynamic> field;
//
//   const DropdownButtonExample({Key? key, required this.field}) : super(key: key);
//
//   @override
//   State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
// }
//
// class _DropdownButtonExampleState extends State<DropdownButtonExample> {
//
//   List<String> list = [];
//   String dropdownValue = "";
//
//   @override
//   void initState() {
//     super.initState();
//     list = widget.field['values'];
//     dropdownValue = list.first;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return DropdownButton<String>(
//       value: dropdownValue,
//       icon: const Icon(Icons.arrow_downward),
//       elevation: 16,
//       style: const TextStyle(color: Colors.deepPurple),
//       underline: Container(
//         height: 2,
//         color: Colors.deepPurpleAccent,
//       ),
//       onChanged: (String? value) {
//         // This is called when the user selects an item.
//         setState(() {
//           dropdownValue = value!;
//         });
//       },
//       items: list.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: AutoSizeText(value),
//         );
//       }).toList(),
//     );
//   }
// }
