import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';

class BSEReminderScreen extends StatefulWidget {
  const BSEReminderScreen({super.key});

  @override
  State<BSEReminderScreen> createState() => _BSEReminderScreenState();
}

class _BSEReminderScreenState extends State<BSEReminderScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'SCHEDULE',
      showTitleInTopBar: true,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // BSE Title
          const Text(
            'BSE REMINDER',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE91E63),
            ),
          ),
          
          const SizedBox(height: 10),
          
          // BSE Description
          Text(
            'Set an automatic monthly reminder. The best time to check your breasts is when they are soft (usually after a period). If you no longer have a period, choose a fixed day each month that will remind you to BSE.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Date Field
          _buildInputField(
            'DATE',
            _selectedDate != null 
                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                : 'Select Date',
            Icons.calendar_today,
            () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFFE91E63), // Pink color matching app theme
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Colors.black87,
                        surfaceTint: Color(0xFFE91E63),
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFFE91E63), // Pink buttons
                        ),
                      ),
                      dialogTheme: const DialogThemeData(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: child!,
                    ),
                  );
                },
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
          ),
          
          const SizedBox(height: 20),
          
          // Time Field
          _buildInputField(
            'TIME',
            _selectedTime != null 
                ? _formatTime(_selectedTime!)
                : 'Select Time',
            Icons.access_time,
            () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFFE91E63), // Pink color matching app theme
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Colors.black87,
                        surfaceTint: Color(0xFFE91E63),
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFFE91E63), // Pink buttons
                        ),
                      ),
                      dialogTheme: const DialogThemeData(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: child!,
                    ),
                  );
                },
              );
              if (picked != null) {
                setState(() {
                  _selectedTime = picked;
                });
              }
            },
          ),
          
          const SizedBox(height: 40),
          
          // Schedule Reminder Button
          _buildScheduleButton(),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String value, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.pink.shade300, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.pink.shade400,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: value.contains('Select') ? Colors.grey.shade500 : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleButton() {
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [Colors.pink.shade300, Colors.pink.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('BSE Reminder scheduled successfully!'),
              ),
            );
            Navigator.pop(context);
          },
          child: const Center(
            child: Text(
              'SCHEDULE\nREMINDER',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
