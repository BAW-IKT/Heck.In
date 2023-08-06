import 'package:flutter/material.dart';

class DropdownInput extends StatefulWidget {
  final Map<String, dynamic> field;
  final Color? borderColor;
  final String currentLocale;
  final Function(String, String) onValueChange;

  DropdownInput({
    required this.field,
    required this.onValueChange,
    required this.currentLocale,
    this.borderColor,
  });

  @override
  _DropdownInputState createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = _initialDropdownValue();
  }

  String _initialDropdownValue() {
    if (!widget.field["values${widget.currentLocale}"]
        .contains(widget.field["selectedValue"])) {
      String otherLanguage = widget.currentLocale == "EN" ? "DE" : "EN";
      int dropdownValueIndex = widget.field["values$otherLanguage"]
          .indexOf(widget.field["selectedValue"]);
      if (dropdownValueIndex != -1) {
        return widget.field["values${widget.currentLocale}"]
            [dropdownValueIndex];
      } else {
        throw Exception(
            'The selectedValue ${widget.field["selectedValue"]} could not be found in either language\'s values');
      }
    } else {
      return widget.field["selectedValue"];
    }
  }

  @override
  Widget build(BuildContext context) {
    String locale = widget.currentLocale;
    var dropdownItems =
        widget.field['values$locale'].map<DropdownMenuItem<String>>((value) {
      String textShort =
          value.length > 30 ? value.substring(0, 27) + "..." : value;
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          textShort,
          style: const TextStyle(
            fontSize: 13,
          ),
        ),
      );
    }).toList();

    return DropdownButtonFormField(
      value: dropdownValue,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: widget.borderColor != null
              ? BorderSide(color: widget.borderColor!)
              : const BorderSide(),
        ),
        labelText: widget.field['label$locale'],
        labelStyle: TextStyle(
          fontSize: widget.field['label$locale'].length > 24 ? 14 : 16,
        ),
      ),
      items: dropdownItems,
      onChanged: (value) {
        widget.onValueChange(widget.field["label"], value.toString());
        setState(() {
          dropdownValue = value.toString();
        });
      },
    );
  }
}
