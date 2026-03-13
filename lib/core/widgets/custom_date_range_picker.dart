import 'package:flutter/material.dart';

import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';

class CustomDateRangePicker extends StatefulWidget {
  final DateTimeRange initialDateRange;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Color? primaryColor;

  const CustomDateRangePicker({
    Key? key,
    required this.initialDateRange,
    this.firstDate,
    this.lastDate,
    this.primaryColor,
  }) : super(key: key);

  static Future<DateTimeRange?> show({
    required BuildContext context,
    required DateTimeRange initialDateRange,
    DateTime? firstDate,
    DateTime? lastDate,
    Color? primaryColor,
  }) async {
    return await showDialog<DateTimeRange>(
      context: context,
      builder: (BuildContext context) {
        return CustomDateRangePicker(
          initialDateRange: initialDateRange,
          firstDate: firstDate ?? DateTime(1990),
          lastDate: lastDate ?? DateTime.now(),
          primaryColor: primaryColor ?? AppTheme.primaryColor,
        );
      },
    );
  }

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  late DateTime focusedDay;
  DateTime? tempStartDate;
  DateTime? tempEndDate;
  bool _isSelectingYear = false;
  bool _isSelectingMonth = false;

  @override
  void initState() {
    super.initState();
    focusedDay = widget.initialDateRange.start;
    tempStartDate = widget.initialDateRange.start;
    tempEndDate = widget.initialDateRange.end;
  }

  Color get primaryColor => widget.primaryColor ?? AppTheme.primaryColor;

  void _selectYear(int year) {
    setState(() {
      focusedDay = DateTime(year, focusedDay.month, 1);
      _isSelectingYear = false;
    });
  }

  void _selectMonth(int month) {
    setState(() {
      focusedDay = DateTime(focusedDay.year, month, 1);
      _isSelectingMonth = false;
    });
  }

  void _previousMonth() {
    setState(() {
      focusedDay = DateTime(focusedDay.year, focusedDay.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      focusedDay = DateTime(focusedDay.year, focusedDay.month + 1, 1);
    });
  }

  void _onDaySelected(DateTime date) {
    setState(() {
      if (tempStartDate == null ||
          (tempStartDate != null && tempEndDate != null)) {
        // Start new selection
        tempStartDate = date;
        tempEndDate = null;
      } else if (date.isBefore(tempStartDate!)) {
        // Selected date is before start, make it the new start
        tempEndDate = tempStartDate;
        tempStartDate = date;
      } else {
        // Complete the range
        tempEndDate = date;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(20),
        constraints: BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 16),
            if (_isSelectingYear)
              _buildYearSelector()
            else if (_isSelectingMonth)
              _buildMonthSelector()
            else ...[
              _buildMonthNavigation(),
              SizedBox(height: 16),
              _buildCalendarGrid(),
              SizedBox(height: 16),
              if (tempStartDate != null) _buildSelectedRangeDisplay(),
              SizedBox(height: 16),
            ],
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Chọn khoảng thời gian',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff262A37),
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, color: Colors.grey[600]),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildMonthNavigation() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: primaryColor),
            onPressed: _previousMonth,
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _isSelectingMonth = true;
                    _isSelectingYear = false;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Tháng ${focusedDay.month}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff262A37),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              InkWell(
                onTap: () {
                  setState(() {
                    _isSelectingYear = true;
                    _isSelectingMonth = false;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${focusedDay.year}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff262A37),
                    ),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: primaryColor),
            onPressed: _nextMonth,
          ),
        ],
      ),
    );
  }

  Widget _buildYearSelector() {
    final currentYear = DateTime.now().year;
    final startYear = widget.firstDate?.year ?? 2000;
    final endYear = widget.lastDate?.year ?? currentYear;

    return Container(
      height: 300,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isSelectingYear = false;
                    });
                  },
                  icon: Icon(Icons.arrow_back, color: primaryColor, size: 20),
                  label: Text(
                    'Chọn năm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff262A37),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: endYear - startYear + 1,
              itemBuilder: (context, index) {
                final year = endYear - index;
                final isSelected = year == focusedDay.year;

                return InkWell(
                  onTap: () => _selectYear(year),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '$year',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected ? Colors.white : Color(0xff262A37),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    final months = [
      'Tháng 1',
      'Tháng 2',
      'Tháng 3',
      'Tháng 4',
      'Tháng 5',
      'Tháng 6',
      'Tháng 7',
      'Tháng 8',
      'Tháng 9',
      'Tháng 10',
      'Tháng 11',
      'Tháng 12',
    ];

    return Container(
      height: 300,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isSelectingMonth = false;
                    });
                  },
                  icon: Icon(Icons.arrow_back, color: primaryColor, size: 20),
                  label: Text(
                    'Chọn tháng - ${focusedDay.year}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff262A37),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final month = index + 1;
                final isSelected = month == focusedDay.month;

                return InkWell(
                  onTap: () => _selectMonth(month),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        months[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected ? Colors.white : Color(0xff262A37),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(focusedDay.year, focusedDay.month, 1);
    final lastDayOfMonth = DateTime(focusedDay.year, focusedDay.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7;
    final now = DateTime.now();
    final lastDate = widget.lastDate ?? now;

    // Fixed height: always show 6 rows (max possible)
    return Container(
      height: 260, // Fixed height để không bị nhảy
      child: Column(
        children: [
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff5C5C5C),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 8),

          // Calendar days - Always 6 rows
          Expanded(
            child: Column(
              children: List.generate(6, (weekIndex) {
                return Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (dayIndex) {
                      final dayNumber =
                          weekIndex * 7 + dayIndex - startWeekday + 1;

                      if (dayNumber < 1 || dayNumber > daysInMonth) {
                        return Expanded(child: SizedBox());
                      }

                      final date = DateTime(
                        focusedDay.year,
                        focusedDay.month,
                        dayNumber,
                      );
                      final isToday =
                          date.year == now.year &&
                          date.month == now.month &&
                          date.day == now.day;
                      final isStartDate =
                          tempStartDate != null &&
                          date.year == tempStartDate!.year &&
                          date.month == tempStartDate!.month &&
                          date.day == tempStartDate!.day;
                      final isEndDate =
                          tempEndDate != null &&
                          date.year == tempEndDate!.year &&
                          date.month == tempEndDate!.month &&
                          date.day == tempEndDate!.day;
                      final isInRange =
                          tempStartDate != null &&
                          tempEndDate != null &&
                          date.isAfter(tempStartDate!) &&
                          date.isBefore(tempEndDate!);
                      final isDisabled = date.isAfter(lastDate);

                      return Expanded(
                        child: GestureDetector(
                          onTap: isDisabled ? null : () => _onDaySelected(date),
                          child: Container(
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: isStartDate || isEndDate
                                  ? primaryColor
                                  : isInRange
                                  ? primaryColor.withOpacity(0.2)
                                  : isToday
                                  ? primaryColor.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: isToday && !isStartDate && !isEndDate
                                  ? Border.all(color: primaryColor, width: 1.5)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '$dayNumber',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                      isStartDate || isEndDate || isToday
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isDisabled
                                      ? Colors.grey[300]
                                      : isStartDate || isEndDate
                                      ? Colors.white
                                      : isInRange
                                      ? primaryColor
                                      : Color(0xff262A37),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedRangeDisplay() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconsaxPlusLinear.calendar, size: 16, color: primaryColor),
          SizedBox(width: 8),
          Text(
            tempEndDate != null
                ? '${DateFormat('dd/MM/yyyy').format(tempStartDate!)} - ${DateFormat('dd/MM/yyyy').format(tempEndDate!)}'
                : '${DateFormat('dd/MM/yyyy').format(tempStartDate!)} - ...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final canApply = tempStartDate != null && tempEndDate != null;

    return Row(
      children: [
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Hủy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff5C5C5C),
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: canApply ? primaryColor : Colors.grey[300],
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: canApply
                ? () {
                    Navigator.pop(
                      context,
                      DateTimeRange(start: tempStartDate!, end: tempEndDate!),
                    );
                  }
                : null,
            child: Text(
              'Áp dụng',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<DateTimeRange?> showCustomDateRangePicker({
  required BuildContext context,
  required DateTimeRange initialDateRange,
  DateTime? firstDate,
  DateTime? lastDate,
  Color? primaryColor,
}) async {
  return await CustomDateRangePicker.show(
    context: context,
    initialDateRange: initialDateRange,
    firstDate: firstDate,
    lastDate: lastDate,
    primaryColor: primaryColor,
  );
}
