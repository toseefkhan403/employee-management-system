import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../data/models/date_selection.dart';
import 'helper_widgets.dart';

class DatePickerDialog extends StatefulWidget {
  final bool isSelectingEndDate;
  final DateTime? startDate;

  const DatePickerDialog(
      {super.key, required this.isSelectingEndDate, this.startDate});

  @override
  _DatePickerDialogState createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<DatePickerDialog> {
  DateTime? _selectedDate = DateTime.now();
  DateSelection _buttonSelection = DateSelection.today;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                widget.isSelectingEndDate
                    ? _buildDateSelectionButton(DateSelection.noDate)
                    : Container(),
                _buildDateSelectionButton(DateSelection.today),
                widget.isSelectingEndDate
                    ? Container()
                    : _buildDateSelectionButton(DateSelection.nextMonday),
              ],
            ),
            widget.isSelectingEndDate
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildDateSelectionButton(DateSelection.nextTuesday),
                      _buildDateSelectionButton(DateSelection.afterOneWeek),
                    ],
                  ),
            tableCalendar(),
            const SizedBox(height: 16.0),
            datePickerBottomRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelectionButton(DateSelection selection) {
    final isSelected = _buttonSelection == selection;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          _handleDateSelection(selection);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Theme.of(context)
                .primaryColor
                .withOpacity(isSelected ? 1 : 0.15),
          ),
          child: Text(
            selection.getButtonText(),
            style: TextStyle(
                color:
                    isSelected ? Colors.white : Theme.of(context).primaryColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _handleDateSelection(DateSelection selection) {
    setState(() {
      _buttonSelection = selection;
      _selectedDate = _getSelectedDate(selection);
    });
  }

  DateTime? _getSelectedDate(DateSelection selection) {
    final now = DateTime.now();
    switch (selection) {
      case DateSelection.today:
        return now;
      case DateSelection.nextMonday:
        return _getNextWeekday(now, DateTime.monday);
      case DateSelection.nextTuesday:
        return _getNextWeekday(now, DateTime.tuesday);
      case DateSelection.afterOneWeek:
        return now.add(const Duration(days: 7));
      case DateSelection.noDate:
        return null;
      default:
        return now;
    }
  }

  DateTime _getNextWeekday(DateTime now, int weekday) {
    final daysUntilNextWeekday = weekday - now.weekday + 7;
    return now.add(Duration(days: daysUntilNextWeekday));
  }

  tableCalendar() => TableCalendar(
        headerStyle:
            const HeaderStyle(titleCentered: true, formatButtonVisible: false),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
        focusedDay: _selectedDate ?? DateTime.now(),
        firstDay: DateTime(2000),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDate, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDate = focusedDay;
          });
        },
        lastDay: DateTime(2101),
      );

  datePickerBottomRow() => Row(
        children: [
          Icon(
            MaterialIcons.event,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            _selectedDate != null
                ? DateFormat('dd MMM yyyy').format(_selectedDate!)
                : "No Date",
          ),
          const Spacer(),
          cancelButton(context),
          saveButton(
            context,
            () {
              if (widget.startDate != null && _selectedDate != null) {
                final date1 = widget.startDate!;
                final date2 = _selectedDate!;
                DateTime date1DateOnly =
                    DateTime(date1.year, date1.month, date1.day);
                DateTime date2DateOnly =
                    DateTime(date2.year, date2.month, date2.day);

                int comparisonResult = date1DateOnly.compareTo(date2DateOnly);
                if (comparisonResult > 0) {
                  showSnackBar(
                      context, "End date cannot be before the start date");
                  return;
                }
              }

              Navigator.pop(context, _selectedDate);
              print('Selected Date: $_selectedDate');
            },
          ),
        ],
      );
}
