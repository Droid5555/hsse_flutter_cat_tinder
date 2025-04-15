import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LikeButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      shape: const CircleBorder(),
      child: Image.asset('assets/buttons/heart.png'),
    );
  }
}
