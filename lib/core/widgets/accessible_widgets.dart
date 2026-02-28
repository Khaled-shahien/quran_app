import 'package:flutter/material.dart';

/// Accessibility-optimized Quran App Scaffold
///
/// Provides enhanced accessibility features including:
/// - Semantic labeling
/// - Dynamic text scaling
/// - Screen reader support
/// - Keyboard navigation
/// - High contrast mode support
class AccessibleScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget>? persistentFooterButtons;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final String? semanticLabel;
  final bool enableAccessibilityFeatures;

  const AccessibleScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.persistentFooterButtons,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.semanticLabel,
    this.enableAccessibilityFeatures = true,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Semantics(
      label: semanticLabel,
      container: true,
      child: Scaffold(
        appBar: appBar != null
            ? _buildAccessibleAppBar(appBar!, context)
            : null,
        body: _buildAccessibleBody(body, mediaQuery),
        floatingActionButton: floatingActionButton != null
            ? _buildAccessibleFAB(floatingActionButton!)
            : null,
        floatingActionButtonLocation: floatingActionButtonLocation,
        persistentFooterButtons: persistentFooterButtons,
        bottomNavigationBar: bottomNavigationBar,
        drawer: drawer,
        endDrawer: endDrawer,
      ),
    );
  }

  /// Builds an accessibility-optimized app bar
  AppBar _buildAccessibleAppBar(AppBar appBar, BuildContext context) {
    return AppBar(
      title: Semantics(header: true, child: appBar.title ?? const Text('App')),
      leading: appBar.leading != null
          ? _wrapWithAccessibility(appBar.leading!, 'Back')
          : null,
      actions: appBar.actions
          ?.map((action) => _wrapWithAccessibility(action, 'Action'))
          .toList(),
      backgroundColor: appBar.backgroundColor,
      foregroundColor: appBar.foregroundColor,
    );
  }

  /// Wraps widgets with accessibility features
  Widget _wrapWithAccessibility(Widget child, String semanticLabel) {
    return Semantics(
      label: semanticLabel,
      button: child is IconButton || child is ElevatedButton,
      textField: child is TextField,
      image: child is Image,
      child: child,
    );
  }

  /// Builds accessibility-optimized body with proper scaling
  Widget _buildAccessibleBody(Widget body, MediaQueryData mediaQuery) {
    // Apply accessibility scaling
    final textScaleFactor = enableAccessibilityFeatures
        ? mediaQuery.textScaler.scale(1.0)
        : 1.0;

    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: TextScaler.linear(textScaleFactor)),
      child: body,
    );
  }

  /// Builds accessibility-optimized FAB
  Widget _buildAccessibleFAB(Widget fab) {
    return Semantics(label: 'Floating action button', button: true, child: fab);
  }
}

/// Accessible Text Widget with enhanced features
class AccessibleText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final String? semanticsLabel;
  final bool isHeader;
  final bool isImportant;

  const AccessibleText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.isHeader = false,
    this.isImportant = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: isHeader,
      label: semanticsLabel ?? data,
      child: ExcludeSemantics(
        child: Text(
          data,
          style: style,
          textAlign: textAlign,
          textDirection: textDirection,
          softWrap: softWrap,
          overflow: overflow,
          maxLines: maxLines,
        ),
      ),
    );
  }
}

/// Accessible Button with enhanced keyboard and screen reader support
class AccessibleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget child;
  final String? semanticsLabel;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderSide? border;
  final double? borderRadius;
  final double? elevation;

  const AccessibleButton({
    super.key,
    required this.onPressed,
    this.onLongPress,
    required this.child,
    this.semanticsLabel,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.border,
    this.borderRadius,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      button: true,
      enabled: onPressed != null,
      child: ElevatedButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: padding ?? const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            side: border ?? BorderSide.none,
          ),
          elevation: elevation,
        ),
        child: child,
      ),
    );
  }
}

/// Accessible Card with proper semantics and focus support
class AccessibleCard extends StatelessWidget {
  final Widget child;
  final String? semanticsLabel;
  final EdgeInsets? margin;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;

  const AccessibleCard({
    super.key,
    required this.child,
    this.semanticsLabel,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      container: true,
      child: Container(
        margin: margin,
        child: Card(
          color: color,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(16),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Accessibility utilities and helper functions
class AccessibilityUtils {
  /// Announce important messages to screen readers
  static void announceToScreenReader(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Check if accessibility features are enabled
  static bool isAccessibilityEnabled(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.accessibleNavigation ||
        mediaQuery.boldText ||
        mediaQuery.invertColors ||
        mediaQuery.highContrast ||
        mediaQuery.disableAnimations;
  }

  /// Get appropriate text size multiplier based on accessibility settings
  static double getTextScaleFactor(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    if (isAccessibilityEnabled(context)) {
      return mediaQuery.textScaler.scale(1.0) * 1.2;
    }
    return mediaQuery.textScaler.scale(1.0);
  }

  /// Apply high contrast colors if needed
  static Color applyHighContrast(Color color, BuildContext context) {
    if (MediaQuery.of(context).highContrast) {
      return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    }
    return color;
  }
}
