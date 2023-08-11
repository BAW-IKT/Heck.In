import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message, {bool success = true}) {
  final colScheme = Theme.of(context).colorScheme;
  final col = success ? colScheme.inversePrimary : colScheme.errorContainer;

  final snackBarContent = Row(
    children: [
      success ? Container() : const Icon(Icons.warning, color: Colors.white),
      const SizedBox(width: 16.0),
      Expanded(
        child: Text(message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white)),
      ),
      IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          })
    ],
  );

  final snackBar = SnackBar(
    duration: const Duration(seconds: 5),
    backgroundColor: col,
    content: snackBarContent,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
