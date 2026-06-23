import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FadeSlideRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  FadeSlideRoute({required this.child})
    : super(
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (_, _, _) => child,
        transitionsBuilder: (context, animation, _, child) {
          if (MediaQuery.of(context).disableAnimations) return child;

          final Animation<double> fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );
          final Animation<Offset> slide =
              Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );

          return FadeTransition(
            opacity: fade,
            child: SlideTransition(position: slide, child: child),
          );
        },
      );
}

CustomTransitionPage<T> buildFadeSlidePage<T>({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, _, child) {
      if (MediaQuery.of(context).disableAnimations) return child;

      final Animation<double> fade = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      );
      final Animation<Offset> slide = Tween<Offset>(
        begin: const Offset(0, 0.04),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}
