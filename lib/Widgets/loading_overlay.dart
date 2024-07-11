import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({super.key, required this.isLoading, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Stack(
              children: [
                ModalBarrier(
                  color: Colors.black.withOpacity(0.7),
                  dismissible: false,
                ),
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
