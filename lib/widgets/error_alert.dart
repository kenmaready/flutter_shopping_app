import 'package:flutter/material.dart';

class ErrorAlert extends StatelessWidget {
  final String actionName;

  const ErrorAlert({Key? key, required this.actionName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: Text(
          'Something went wrong when attempting to $actionName the product to the Blamazon product database...'),
      actions: [
        TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
    );
  }
}
