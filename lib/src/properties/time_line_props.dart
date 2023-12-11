import 'package:easy_date_timeline/src/utils/easy_constants.dart';
import 'package:flutter/material.dart' show Color, EdgeInsets, BoxDecoration;

final class EasyTimeLineProps {
  const EasyTimeLineProps({
    this.hPadding = EasyConstants.timelinePadding,
    this.vPadding = 0.0,
    this.separatorPadding = EasyConstants.separatorPadding,
    this.backgroundColor,
    this.margin,
    this.decoration,
    this.autoCenter = false,
    this.animateOnDayChanged = false,
  });

  /// The padding applied to the date timeline widget from left and right.
  final double hPadding;

  /// The padding applied to the date timeline widget from top and bottom.
  final double vPadding;

  /// The padding applied to the separators between days in the timeline widget.
  final double separatorPadding;

  /// The background color of the timeline widget.
  final Color? backgroundColor;

  /// The margin of the timeline widget.
  final EdgeInsets? margin;

  /// The decoration of the timeline widget.
  final BoxDecoration? decoration;

  /// Automatically centers the day in the timeline.
  /// If set to `true`, the timeline will automatically scroll to center the day.
  /// If set to `false`, the timeline will not scroll when the day changes.
  final bool autoCenter;

  /// If set to `true`, the timeline will animate when the day changes.
  /// If set to `false`, the timeline will not animate when the day changes.
  final bool animateOnDayChanged;
}
