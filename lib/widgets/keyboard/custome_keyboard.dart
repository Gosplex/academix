import 'package:flutter/material.dart';

import 'keyboards_key.dart';

class CustomKeyboard extends StatefulWidget {
  const CustomKeyboard({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  late List<List<dynamic>> keys;
  late String phoneNumber;

  @override
  initState() {
    super.initState();

    keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['0', '00', const Icon(Icons.keyboard_backspace)],
    ];

    phoneNumber = '';
  }

  renderKeyboard() {
    return keys
        .map(
          (x) => Row(
            children: x.map(
              (y) {
                return Expanded(
                  child: KeyboardKeys(
                    label: y,
                    onKeyTap: (value) {
                      onKeyTap(value);
                    },
                    value: y,
                  ),
                );
              },
            ).toList(),
          ),
        )
        .toList();
  }

  onKeyTap(value) {
    if (value is Icon) {
      if (phoneNumber.isNotEmpty) {
        setState(() {
          phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
          widget.controller.text = phoneNumber;
        });
      }
    } else {
      setState(() {
      //  Set limit to 10 characters
        if (phoneNumber.length < 10) {
          phoneNumber = phoneNumber + value;
          widget.controller.text = phoneNumber;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        ...renderKeyboard(),
      ]),
    );
  }
}
