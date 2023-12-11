part of 'infinite_time_line_widget.dart';

/// Controller for managing the EasyInfiniteDateTimeline view.
class EasyInfiniteDateTimelineController {
  _InfiniteTimeLineWidgetState? _infiniteTimeLineState;

  /// Attach the controller to the EasyInfiniteDateTimeline view state.
  void _attachEasyDateState(_InfiniteTimeLineWidgetState state) {
    _infiniteTimeLineState = state;
  }

  /// Jump to the currently focused date on the timeline.
  void jumpToFocusDate() {
    assert(
      _infiniteTimeLineState != null,
      'EasyInfiniteDateTimelineController is not attached to any EasyInfiniteDateTimeline View.',
    );
    final offset = _calculateOffset(_infiniteTimeLineState!._focusDate);
    _infiniteTimeLineState!._controller.jumpTo(offset);
  }

  /// Animate to the currently focused date on the timeline.
  void animateToFocusDate({
    duration = const Duration(milliseconds: 300),
    curve = Curves.linear,
  }) {
    assert(
      _infiniteTimeLineState != null,
      'EasyInfiniteDateTimelineController is not attached to any EasyInfiniteDateTimeline View.',
    );
    final offset = _calculateOffset(_infiniteTimeLineState!._focusDate);
    _infiniteTimeLineState!._controller.animateTo(
      offset,
      duration: duration,
      curve: curve,
    );
  }

  /// Animate the timeline to a specified date.
  void animateToDate(
    DateTime date, {
    duration = const Duration(milliseconds: 300),
    curve = Curves.linear,
  }) {
    assert(
      _infiniteTimeLineState != null,
      'EasyInfiniteDateTimelineController is not attached to any EasyInfiniteDateTimeline View.',
    );
    double offset = _calculateOffset(date);
    _infiniteTimeLineState!._controller.animateTo(
      offset,
      duration: duration,
      curve: curve,
    );
  }

  /// Animate the timeline to a specified date.
  void animateToCurrentData({
    duration = const Duration(milliseconds: 300),
    curve = Curves.linear,
  }) {
    assert(
      _infiniteTimeLineState != null,
      'EasyInfiniteDateTimelineController is not attached to any EasyInfiniteDateTimeline View.',
    );
    final offset = _calculateOffset(DateTime.now());
    _infiniteTimeLineState!._controller.animateTo(
      offset,
      duration: duration,
      curve: curve,
    );
  }

  /// Jump the timeline to a specified date.
  void jumpToDate(
    DateTime date,
  ) {
    assert(
      _infiniteTimeLineState != null,
      'EasyInfiniteDateTimelineController is not attached to any EasyInfiniteDateTimeline View.',
    );
    final offset = _calculateDateOffset(date);
    _infiniteTimeLineState!._controller.jumpTo(
      offset,
    );
  }

  /// Calculates the scroll offset for a given date.
  ///
  /// This method calculates the offset for the given date and adjusts it based on whether the timeline should auto-center.
  /// If `autoCenter` is true, the offset is adjusted by subtracting `_dayOffsetCenterConstrains` to center the date in the timeline.
  /// If `autoCenter` is false, the offset is not adjusted.
  ///
  /// @param date The date for which to calculate the offset.
  /// @return The calculated offset.
  double _calculateOffset(DateTime date) {
    final autoCenter = _infiniteTimeLineState!.widget.autoCenter;
    final offset = _calculateDateOffset(date) -
        (autoCenter ? _infiniteTimeLineState!._dayOffsetCenterConstrains : 0.0);
    return offset;
  }

  /// the method calculates the number of days between startDate and lastDate using the difference() method
  /// of the Duration class. This value is stored in the offset variable.
  /// If offset is equal to 0, the method returns 0.0.
  /// Otherwise, the method calculates the horizontal offset of the day
  /// by multiplying the offset value by the width of a day widget
  /// (which is either the value of widget.easyDayProps.width or a default value of EasyConstants.dayWidgetWidth).
  /// It then adds to this value the product of offset and [EasyConstants.separatorPadding] (which represents the width of the space between each day widget)
  double _calculateDateOffset(DateTime lastDate) {
    final firstDate = _infiniteTimeLineState!.widget.firstDate;
    int offset = lastDate.difference(firstDate).inDays;
    double adjustedHPadding = _infiniteTimeLineState!._timeLineProps.hPadding >
            EasyConstants.timelinePadding
        ? (_infiniteTimeLineState!._timeLineProps.hPadding -
            EasyConstants.timelinePadding)
        : 0.0;
    if (offset == 0) {
      return 0.0;
    }
    return (offset * _infiniteTimeLineState!._dayOffsetConstrains) +
        adjustedHPadding;
  }
}
