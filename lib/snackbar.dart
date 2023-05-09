import 'dart:async';
import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message, {bool success = true}) async {
  int elapsedTime = 0;
  int duration = 100;

  final progress = ValueNotifier<double>(0.0);

  final snackBar = SnackBar(
    duration: Duration(seconds: duration),
    content: ValueListenableBuilder<double>(
      valueListenable: progress,
      builder: (context, value, child) {
        return Row(
          children: [
            SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation<Color>(success ? Colors.blue : Colors.red),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Center(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: success ? null : Colors.red,),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ],
        );
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);

  Timer.periodic(const Duration(milliseconds: 50), (timer) {
    progress.value = ++elapsedTime / duration;
    if (elapsedTime == duration) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      timer.cancel();
    }
  });
}
