import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResizeState {
  final int targetW;
  final int targetH;
  final bool isResizing;

  const ResizeState({
    this.targetW = 0,
    this.targetH = 0,
    this.isResizing = false,
  });
}

class ResizeStateNotifier extends FamilyNotifier<ResizeState, String> {
  @override
  ResizeState build(String arg) {
    return const ResizeState();
  }

  void update(int w, int h, bool resizing) {
    state = ResizeState(targetW: w, targetH: h, isResizing: resizing);
  }
}

final resizeStateProvider = NotifierProvider.family<ResizeStateNotifier, ResizeState, String>(ResizeStateNotifier.new);
