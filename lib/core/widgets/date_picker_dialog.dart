import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_app/config/theme/app_colors.dart';
import 'package:flutter_test_app/config/theme/app_text_styles.dart';
import 'package:flutter_test_app/core/utils/extensions.dart';
import 'package:flutter_test_app/core/widgets/app_dialog.dart';

Future<DateTime?> datePickerDialog({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? lastDate,
  bool Function(DateTime date)? isDateEnabled,
}) {
  return AppDialog.show<DateTime>(
    context: context,
    title: '',
    showCloseButton: false,
    child: _DatePickerDialog(
      initialDate: initialDate,
      lastDate: lastDate,
      isDateEnabled: isDateEnabled,
    ),
  );
}

class _DatePickerDialogValue {
  final DateTime selectedDate;
  final DateTime displayedMonth;

  const _DatePickerDialogValue({
    required this.selectedDate,
    required this.displayedMonth,
  });

  _DatePickerDialogValue copyWith({
    DateTime? selectedDate,
    DateTime? displayedMonth,
  }) => _DatePickerDialogValue(
    selectedDate: selectedDate ?? this.selectedDate,
    displayedMonth: displayedMonth ?? this.displayedMonth,
  );
}

class _DatePickerDialog extends StatefulWidget {
  const _DatePickerDialog({
    this.initialDate,
    this.lastDate,
    this.isDateEnabled,
  });

  final DateTime? initialDate;
  final DateTime? lastDate;
  final bool Function(DateTime date)? isDateEnabled;

  @override
  State<_DatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<_DatePickerDialog> {
  static const List<String> _weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  late final ValueNotifier<_DatePickerDialogValue> _notifier;
  late final PageController _pageController;
  late final DateTime _baseMonth;
  int _monthSlideDirection = 0;

  static const int _initialPage = 1200;

  @override
  void initState() {
    super.initState();
    final initialDate = widget.initialDate ?? DateTime.now();
    _baseMonth = DateTime(initialDate.year, initialDate.month);
    _pageController = PageController(initialPage: _initialPage);
    _notifier = ValueNotifier(
      _DatePickerDialogValue(
        selectedDate: initialDate,
        displayedMonth: _baseMonth,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _notifier.dispose();
    super.dispose();
  }

  DateTime _monthForPage(int page) {
    return DateTime(
      _baseMonth.year,
      _baseMonth.month + (page - _initialPage),
    );
  }

  int _weekRowCountForMonth(DateTime month) {
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final leadingCount = firstOfMonth.weekday - 1;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final trailingCount = (7 - ((leadingCount + daysInMonth) % 7)) % 7;
    return (leadingCount + daysInMonth + trailingCount) ~/ 7;
  }

  double _gridHeightForRows(double cellWidth, int rowCount) {
    return rowCount * cellWidth + (rowCount - 1) * 8.h;
  }

  void _onPageChanged(int page) {
    final oldMonth = _notifier.value.displayedMonth;
    final newMonth = _monthForPage(page);
    final last = widget.lastDate;
    if (last != null) {
      final maxIndex = last.year * 12 + last.month;
      final newIndex = newMonth.year * 12 + newMonth.month;
      if (newIndex > maxIndex) {
        final maxMonth = DateTime(last.year, last.month);
        final monthOffset =
            (maxMonth.year - _baseMonth.year) * 12 +
            (maxMonth.month - _baseMonth.month);
        final maxPage = _initialPage + monthOffset;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.jumpToPage(maxPage);
          }
        });
        return;
      }
    }
    final oldIndex = oldMonth.year * 12 + oldMonth.month;
    final newIndex = newMonth.year * 12 + newMonth.month;
    _monthSlideDirection = newIndex > oldIndex ? 1 : -1;
    _notifier.value = _notifier.value.copyWith(displayedMonth: newMonth);
  }

  void _previousMonth() {
    _monthSlideDirection = -1;
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _nextMonth() {
    _monthSlideDirection = 1;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _goToMonth(DateTime month) {
    final monthOffset =
        (month.year - _baseMonth.year) * 12 + (month.month - _baseMonth.month);
    final targetPage = _initialPage + monthOffset;
    if (!_pageController.hasClients) return;
    final currentPage = _pageController.page?.round() ?? _initialPage;
    if (currentPage == targetPage) return;

    _monthSlideDirection = targetPage > currentPage ? 1 : -1;
    _pageController.animateToPage(
      targetPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _selectDate(DateTime date) {
    if (!_isDateSelectable(date)) {
      return;
    }
    _notifier.value = _notifier.value.copyWith(
      selectedDate: date,
      displayedMonth: DateTime(date.year, date.month),
    );
    _goToMonth(DateTime(date.year, date.month));
  }

  bool _isDateSelectable(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    final last = widget.lastDate;
    if (last != null) {
      final lastDay = DateTime(last.year, last.month, last.day);
      if (day.isAfter(lastDay)) return false;
    }
    return widget.isDateEnabled?.call(date) ?? true;
  }

  bool _canNavigateForward(_DatePickerDialogValue value) {
    final last = widget.lastDate;
    if (last == null) return true;
    final displayedIndex =
        value.displayedMonth.year * 12 + value.displayedMonth.month;
    final lastIndex = last.year * 12 + last.month;
    return displayedIndex < lastIndex;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<_DatePickerDialogValue>(
      valueListenable: _notifier,
      builder: (context, value, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMonthHeader(context, value),
          18.verticalSpace,
          _buildDateGrid(context, value),
          16.verticalSpace,
          ElevatedButton(
            onPressed: () =>
                Navigator.of(context).pop(value.selectedDate),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(200, 40.h),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: context.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.r),
              ),
            ),
            child: Text(
              'Ok',
              style: context.textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          8.verticalSpace,
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(200, 24.h),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Cancel',
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(BuildContext context, _DatePickerDialogValue value) {
    return Row(
      children: [
        _buildHeaderIcon(icon: Icons.chevron_left, onPressed: _previousMonth),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              final slideOffset = _monthSlideDirection >= 0 ? 0.15 : -0.15;
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(slideOffset, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              '${_monthNames[value.displayedMonth.month - 1]} ${value.displayedMonth.year}',
              key: ValueKey(
                '${value.displayedMonth.year}-${value.displayedMonth.month}',
              ),
              textAlign: TextAlign.center,
              style: AppTextStyles.w700_18.copyWith(color: textColor),
            ),
          ),
        ),
        _buildHeaderIcon(
          icon: Icons.chevron_right,
          onPressed: _canNavigateForward(value) ? _nextMonth : null,
        ),
      ],
    );
  }

  Widget _buildHeaderIcon({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size(30.r, 30.r),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: Colors.transparent,
      ),
      icon: Icon(
        icon,
        color: onPressed == null
            ? const Color(0xFFCBD5E1)
            : const Color(0xFF111827),
        size: 28.r,
      ),
    );
  }

  Widget _buildDateGrid(BuildContext context, _DatePickerDialogValue value) {
    return Container(
      padding: EdgeInsets.all(13.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final gridWidth = constraints.maxWidth;
          final cellWidth = (gridWidth - 6 * 8.w) / 7;
          final rowCount = _weekRowCountForMonth(value.displayedMonth);
          final gridHeight = _gridHeightForRows(cellWidth, rowCount);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  for (final weekDay in _weekDays)
                    Expanded(
                      child: Center(
                        child: Text(
                          weekDay,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: const Color(0xFF7883A0),
                            fontFamily: urbanist,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              12.verticalSpace,
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: gridHeight,
                  width: gridWidth,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, page) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: _buildMonthCells(
                          context,
                          value: value,
                          displayedMonth: _monthForPage(page),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMonthCells(
    BuildContext context, {
    required _DatePickerDialogValue value,
    required DateTime displayedMonth,
  }) {
    final firstOfMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month,
      1,
    );
    final firstWeekday = firstOfMonth.weekday;
    final daysInMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      0,
    ).day;
    final previousMonthDays = DateTime(
      displayedMonth.year,
      displayedMonth.month,
      0,
    ).day;

    final leadingCount = firstWeekday - 1;
    final totalCells = leadingCount + daysInMonth;
    final trailingCount = (7 - (totalCells % 7)) % 7;

    final cells = <DateTime>[];
    for (var i = 0; i < leadingCount; i++) {
      final day = previousMonthDays - leadingCount + i + 1;
      cells.add(
        DateTime(
          displayedMonth.year,
          displayedMonth.month - 1,
          day,
        ),
      );
    }
    for (var day = 1; day <= daysInMonth; day++) {
      cells.add(
        DateTime(displayedMonth.year, displayedMonth.month, day),
      );
    }
    for (var day = 1; day <= trailingCount; day++) {
      cells.add(
        DateTime(
          displayedMonth.year,
          displayedMonth.month + 1,
          day,
        ),
      );
    }

    return GridView.builder(
      itemCount: cells.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
      ),
      itemBuilder: (_, index) {
        final date = cells[index];
        final isSelected = DateUtils.isSameDay(value.selectedDate, date);
        final isCurrentMonth = date.month == displayedMonth.month;
        final isEnabled = _isDateSelectable(date);

        return InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: isEnabled ? () => _selectDate(date) : null,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? context.colorScheme.primary
                  : isEnabled
                  ? const Color(0xFFF8F9FE)
                  : const Color(0xFFF1F3F8),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              date.day.toString().padLeft(2, '0'),
              style: context.textTheme.labelMedium?.copyWith(
                fontFamily: urbanist,
                color: isSelected
                    ? Colors.white
                    : !isEnabled
                    ? const Color(0xFFCBD5E1)
                    : isCurrentMonth
                    ? const Color(0xFF5A6274)
                    : const Color(0xFFA0AEC0),
              ),
            ),
          ),
        );
      },
    );
  }
}
