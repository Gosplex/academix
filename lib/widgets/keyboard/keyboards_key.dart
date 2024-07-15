import 'package:flutter/material.dart';

class KeyboardKeys extends StatefulWidget {
  const KeyboardKeys({
    super.key,
    required this.label,
    required this.value,
    required this.onKeyTap,
  });

  final dynamic label;
  final dynamic value;
  final ValueSetter<dynamic> onKeyTap;

  @override
  State<KeyboardKeys> createState() => _KeyboardKeysState();
}

class _KeyboardKeysState extends State<KeyboardKeys> {
  renderLabel() {
    if (widget.label is Icon) {
      return widget.label;
    }
    return Text(
      widget.label,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onKeyTap(widget.value);
      },
      child: AspectRatio(
        aspectRatio: 2,
        child: Container(
          child: Center(
            child: renderLabel(),
          ),
        ),
      ),
    );
  }
}
