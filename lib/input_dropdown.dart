import 'package:flutter/material.dart';

class DropdownInput extends StatefulWidget {
  final Map<String, dynamic> field;
  final Color? borderColor;
  final String currentLocale;
  final Function(String, String) onValueChange;

  DropdownInput({
    Key? key,
    required this.field,
    required this.onValueChange,
    required this.currentLocale,
    this.borderColor,
  }) : super(key: key);

  @override
  _DropdownInputState createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = _getLocalizedInitialDropdownValue();
  }

  String _getLocalizedInitialDropdownValue() {
    String selected = "";
    if (widget.field.containsKey("selectedValue")) {
      selected = widget.field["selectedValue"];

      /// on first build (app launch) the selected value is in the current
      /// locale; on rebuild (e.g. after language switch), the selected value
      /// is from the "values" list and needs to be translated to locale again
      int idxInValues = widget.field["values"].indexOf(selected);
      if (idxInValues > 0) {
        selected = widget.field["values${widget.currentLocale}"][idxInValues];
      }

    }
    return selected;
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
