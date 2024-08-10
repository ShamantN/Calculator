// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumbersButton extends StatefulWidget {
  final String number;
  final Color backgroundColor;
  final Function()? onTap;

  const NumbersButton({
    super.key,
    required this.number,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  _NumbersButtonState createState() => _NumbersButtonState();
}

class _NumbersButtonState extends State<NumbersButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        HapticFeedback.heavyImpact();
      },
      onTapUp: (_) {
        _controller.reverse();
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: CircleAvatar(
          radius: 45,
          backgroundColor: widget.backgroundColor,
          child: Text(
            widget.number,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white70,
              fontSize: 35,
            ),
          ),
        ),
      ),
    );
  }
}
