import 'package:flutter/material.dart';

class DislikeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DislikeButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      shape: const CircleBorder(),
      child: Image.asset('assets/buttons/cross.png'),
    );
  }
}
