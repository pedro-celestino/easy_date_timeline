import 'package:flutter/material.dart';

import '../../properties/easy_day_props.dart';
import '../../properties/time_line_props.dart';
import '../../utils/utils.dart';
import '../easy_day_widget/easy_day_widget.dart';

/// A widget that displays a timeline of days.
class TimeLineWidget extends StatefulWidget {
  TimeLineWidget({
    super.key,
    required this.initialDate,
    required this.focusedDate,
    required this.activeDayTextColor,
    required this.activeDayColor,
    this.inactiveDates,
    this.dayProps = const EasyDayProps(),
    this.locale = "en_US",
    this.timeLineProps = const EasyTimeLineProps(),
    this.onDateChange,
    this.itemBuilder,
    this.autoCenter = false,
    this.animateOnDayChanged = false,
  })  : assert(timeLineProps.hPadding > -1,
            "Can't set timeline hPadding less than zero."),
        assert(timeLineProps.separatorPadding > -1,
            "Can't set timeline separatorPadding less than zero."),
        assert(timeLineProps.vPadding > -1,
            "Can't set timeline vPadding less than zero.");

  /// Represents the initial date for the timeline widget.
  /// This is the date that will be displayed as the first day in the timeline.
  final DateTime initialDate;

  /// The currently focused date in the timeline.
  final DateTime? focusedDate;

  /// The color of the text for the selected day.
  final Color activeDayTextColor;

  /// The background color of the selected day.
  final Color activeDayColor;

  /// Automatically centers the day in the timeline.
  /// If set to `true`, the timeline will automatically scroll to center the day.
  /// If set to `false`, the timeline will not scroll when the day changes.
  final bool autoCenter;

  /// If set to `true`, the timeline will animate when the day changes.
  /// If set to `false`, the timeline will not animate when the day changes.
  final bool animateOnDayChanged;

  /// Represents a list of inactive dates for the timeline widget.
  /// Note that all the dates defined in the inactiveDates list will be deactivated.
  final List<DateTime>? inactiveDates;

  /// Contains properties for configuring the appearance and behavior of the timeline widget.
  /// This object includes properties such as the height of the timeline, the color of the selected day,
  /// and the animation duration for scrolling.
  final EasyTimeLineProps timeLineProps;

  /// Contains properties for configuring the appearance and behavior of the day widgets in the timeline.
  /// This object includes properties such as the width and height of each day widget,
  /// the color of the text and background, and the font size.
  final EasyDayProps dayProps;

  /// Called when the selected date in the timeline changes.
  /// This function takes a `DateTime` object as its parameter, which represents the new selected date.
  final OnDateChangeCallBack? onDateChange;

  /// Called for each day in the timeline, allowing the developer to customize the appearance and behavior of each day widget.
  /// This function takes a `BuildContext` and a `DateTime` object as its parameters, and should return a `Widget` that represents the day.
  final ItemBuilderCallBack? itemBuilder;

  /// A `String` that represents the locale code to use for formatting the dates in the timeline.
  final String locale;

  @override
  State<TimeLineWidget> createState() => _TimeLineWidgetState();
}

class _TimeLineWidgetState extends State<TimeLineWidget> {
  EasyDayProps get _dayProps => widget.dayProps;
  EasyTimeLineProps get _timeLineProps => widget.timeLineProps;
  bool get _isLandscapeMode => _dayProps.landScapeMode;
  double get _dayWidth => _dayProps.width;
  double get _dayHeight => _dayProps.height;
  double get _dayOffsetConstrains => _isLandscapeMode ? _dayHeight : _dayWidth;
  double get _dayOffsetCenterConstrains =>
      (MediaQuery.of(context).size.width - _dayOffsetConstrains) / 2.09;

  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    final initialDateOffset = _calculateDateOffset(widget.initialDate);
    _controller = ScrollController(initialScrollOffset: initialDateOffset);
    if (widget.autoCenter) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _jumpToCenter(initialDateOffset);
      });
    }
  }

  void _jumpToCenter(double initialDateOffset) {
    _controller.jumpTo(
      initialDateOffset - _dayOffsetCenterConstrains,
    );
  }

  void _animateToCenter(DateTime currentDate) {
    _controller.animateTo(
      _calculateDateOffset(currentDate) -
          (MediaQuery.of(context).size.width - _dayOffsetConstrains) / 2.09,
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
    );
  }

  void _animateToStart(DateTime currentDate) {
    _controller.animateTo(
      _calculateDateOffset(currentDate),
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// the method calculates the number of days between startDate and date using the difference() method
  /// of the Duration class. This value is stored in the offset variable.
  /// If offset is equal to 0, the method returns 0.0.
  /// Otherwise, the method calculates the horizontal offset of the day
  /// by multiplying the offset value by the width of a day widget
  /// (which is either the value of widget.easyDayProps.width or a default value of EasyConstants.dayWidgetWidth).
  /// It then adds to this value the product of offset and [EasyConstants.separatorPadding] (which represents the width of the space between each day widget)
  double _calculateDateOffset(DateTime date) {
    final startDate = DateTime(date.year, date.month, 1);
    int offset = date.difference(startDate).inDays;
    double adjustedHPadding =
        _timeLineProps.hPadding > EasyConstants.timelinePadding
            ? (_timeLineProps.hPadding - EasyConstants.timelinePadding)
            : 0.0;
    if (offset == 0) {
      return 0.0;
    }
    return (offset * _dayOffsetConstrains) +
        (offset * _timeLineProps.separatorPadding) +
        adjustedHPadding;
  }

  @override
  Widget build(BuildContext context) {
    final initialDate = widget.initialDate;

    return Container(
      height: _isLandscapeMode ? _dayWidth : _dayHeight,
      margin: _timeLineProps.margin,
      color: _timeLineProps.decoration == null
          ? _timeLineProps.backgroundColor
          : null,
      decoration: _timeLineProps.decoration,
      child: ClipRRect(
        borderRadius:
            _timeLineProps.decoration?.borderRadius ?? BorderRadius.zero,
        child: ListView.separated(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: _timeLineProps.hPadding,
            vertical: _timeLineProps.vPadding,
          ),
          itemBuilder: (context, index) {
            final currentDate =
                DateTime(initialDate.year, initialDate.month, index + 1);

            final isSelected = widget.focusedDate != null
                ? EasyDateUtils.isSameDay(widget.focusedDate!, currentDate)
                : EasyDateUtils.isSameDay(widget.initialDate, currentDate);

            bool isDisabledDay = false;
            // Check if this date should be deactivated only for the DeactivatedDates.
            if (widget.inactiveDates != null) {
              for (DateTime inactiveDate in widget.inactiveDates!) {
                if (EasyDateUtils.isSameDay(currentDate, inactiveDate)) {
                  isDisabledDay = true;
                  break;
                }
              }
            }
            return widget.itemBuilder != null
                ? _dayItemBuilder(
                    context,
                    isSelected,
                    currentDate,
                  )
                : EasyDayWidget(
                    easyDayProps: _dayProps,
                    date: currentDate,
                    locale: widget.locale,
                    isSelected: isSelected,
                    isDisabled: isDisabledDay,
                    onDayPressed: () => _onDayChanged(isSelected, currentDate),
                    activeTextColor: widget.activeDayTextColor,
                    activeDayColor: widget.activeDayColor,
                  );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              width: _timeLineProps.separatorPadding,
            );
          },
          itemCount: EasyDateUtils.getDaysInMonth(initialDate),
        ),
      ),
    );
  }

  InkWell _dayItemBuilder(
    BuildContext context,
    bool isSelected,
    DateTime date,
  ) {
    return InkWell(
      onTap: () => _onDayChanged(isSelected, date),
      borderRadius: BorderRadius.circular(_dayProps.activeBorderRadius),
      child: widget.itemBuilder!(
        context,
        date.day.toString(),
        EasyDateFormatter.shortDayName(date, widget.locale).toUpperCase(),
        EasyDateFormatter.shortMonthName(date, widget.locale).toUpperCase(),
        date,
        isSelected,
      ),
    );
  }

  void _onDayChanged(bool isSelected, DateTime currentDate) {
    // A date is selected
    widget.onDateChange?.call(currentDate);
    // Mantain the selected day in the center of the timeline
    if (widget.animateOnDayChanged) {
      if (widget.autoCenter) {
        _animateToCenter(currentDate);
      } else {
        _animateToStart(currentDate);
      }
    }
  }
}
