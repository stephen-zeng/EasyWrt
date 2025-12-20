import 'dart:io';
import 'package:flutter/material.dart';

class EmbeddedNativeControlAreaMoveDown extends StatelessWidget {
  /// The widget won't draw anything, just a placeholder for native window control.
  /// It only works on macOS at the moment.
  /// windows and linux have no way to embed native window control into flutter view.
  const EmbeddedNativeControlAreaMoveDown({
    super.key,
    required this.child,
    this.requireOffset = true,
  });

  final Widget child;
  final bool requireOffset;

  EdgeInsets get _insets {
    if (!requireOffset) {
      return EdgeInsets.zero;
    }
    if (Platform.isMacOS) {
      return const EdgeInsets.only(top: 28); // Standard traffic light height
    } else {
      return EdgeInsets.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _insets,
      child: child,
    );
  }
}

class EmbeddedNativeControlAreaMoveRight extends StatelessWidget {
  /// The widget won't draw anything, just a placeholder for native window control.
  /// It only works on macOS at the moment.
  /// windows and linux have no way to embed native window control into flutter view.
  const EmbeddedNativeControlAreaMoveRight({
    super.key,
    required this.child,
    this.requireOffset = true,
  });

  final Widget child;
  final bool requireOffset;

  EdgeInsets get _insets {
    if (!requireOffset) {
      return EdgeInsets.zero;
    }
    if (Platform.isMacOS) {
      return const EdgeInsets.only(left: 56); // Standard traffic light height
    } else {
      return EdgeInsets.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _insets,
      child: child,
    );
  }
}