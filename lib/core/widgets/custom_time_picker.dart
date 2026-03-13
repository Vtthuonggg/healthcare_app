import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../theme/app_theme.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final Color? primaryColor;
  final bool use24HourFormat;

  const CustomTimePicker({
    Key? key,
    required this.initialTime,
    this.primaryColor,
    this.use24HourFormat = true,
  }) : super(key: key);

  static Future<TimeOfDay?> show({
    required BuildContext context,
    required TimeOfDay initialTime,
    Color? primaryColor,
    bool use24HourFormat = true,
  }) async {
    return await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return CustomTimePicker(
          initialTime: initialTime,
          primaryColor: primaryColor ?? AppTheme.primaryColor,
          use24HourFormat: use24HourFormat,
        );
      },
    );
  }

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late int selectedHour;
  late int selectedMinute;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  @override
  void initState() {
    super.initState();
    selectedHour = widget.initialTime.hour;
    selectedMinute = widget.initialTime.minute;

    // Initialize FixedExtentScrollController with initial item
    _hourController = FixedExtentScrollController(initialItem: selectedHour);
    _minuteController = FixedExtentScrollController(
      initialItem: selectedMinute,
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  Color get primaryColor => widget.primaryColor ?? AppTheme.primaryColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(20),
        constraints: BoxConstraints(maxWidth: 350),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            SizedBox(height: 24),
            _buildTimeDisplay(),
            SizedBox(height: 24),
            _buildTimeSelector(),
            SizedBox(height: 24),
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
          'Chọn thời gian',
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

  Widget _buildTimeDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconsaxPlusLinear.clock_1, size: 35, color: primaryColor),
          SizedBox(width: 12),
          Text(
            '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: primaryColor,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Hour selector
          Expanded(
            child: _buildScrollSelector(
              controller: _hourController,
              itemCount: 24,
              selectedValue: selectedHour,
              onChanged: (value) {
                setState(() {
                  selectedHour = value;
                });
              },
              label: 'Giờ',
            ),
          ),
          Container(
            width: 2,
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 75),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Minute selector
          Expanded(
            child: _buildScrollSelector(
              controller: _minuteController,
              itemCount: 60,
              selectedValue: selectedMinute,
              onChanged: (value) {
                setState(() {
                  selectedMinute = value;
                });
              },
              label: 'Phút',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollSelector({
    required FixedExtentScrollController controller,
    required int itemCount,
    required int selectedValue,
    required Function(int) onChanged,
    required String label,
  }) {
    return Stack(
      children: [
        // Center highlight
        Center(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.15),
              borderRadius: label == 'Giờ'
                  ? BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(0),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(8),
                    ),
            ),
          ),
        ),
        // Scrollable list with ListWheelScrollView
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              // Update selected value when scroll ends
              final int centerItem = controller.selectedItem;
              if (centerItem != selectedValue) {
                onChanged(centerItem);
              }
            }
            return true;
          },
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 50,
            diameterRatio: 1.5,
            physics: FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              onChanged(index);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                if (index < 0 || index >= itemCount) return null;
                final isSelected = index == selectedValue;
                return Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: isSelected ? 28 : 18,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w400,
                      color: isSelected ? primaryColor : Colors.grey[400],
                    ),
                  ),
                );
              },
              childCount: itemCount,
            ),
          ),
        ),
        // Label at bottom
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
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
              backgroundColor: primaryColor,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(
                context,
                TimeOfDay(hour: selectedHour, minute: selectedMinute),
              );
            },
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
