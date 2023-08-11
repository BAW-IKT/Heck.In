import 'package:auto_size_text/auto_size_text.dart';
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
      return DropdownMenuItem<String>(
        value: value,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: AutoSizeText(
            value,
            style: const TextStyle(fontSize: 13),
            maxLines: 1,
            minFontSize: 8,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }).toList();

    return DropdownButtonFormField(
      isExpanded: true,
      value: dropdownValue,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: widget.borderColor != null
              ? BorderSide(color: widget.borderColor!)
              : const BorderSide(),
        ),
        labelText: widget.field['label$locale'],
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
