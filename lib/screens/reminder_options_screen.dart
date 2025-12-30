import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';
import 'doctor_visit_reminder_screen.dart';
import 'bse_reminder_screen.dart';

class ReminderOptionsScreen extends StatelessWidget {
  const ReminderOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'SCHEDULE',
      showTitleInTopBar: true,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          // Two circular buttons with images
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildReminderButton(
                context,
                '',
                'assets/images/doctor_visit.png',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DoctorVisitReminderScreen()),
                ),
              ),
              _buildReminderButton(
                context,
                '',
                'assets/images/bse_reminder.png',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BSEReminderScreen()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReminderButton(
    BuildContext context,
    String text,
    String imagePath,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 140,
        child: Center(
          child: Image.asset(
            imagePath,
            height: 100,
            width: 100,
            errorBuilder: (_, __, ___) => Icon(
              Icons.medical_services,
              size: 80,
              color: Colors.pink.shade400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.pink.shade200, width: 1),
      ),
      child: Icon(
        icon,
        color: Colors.pink.shade400,
        size: 20,
      ),
    );
  }
}

class _ReminderFormScreen extends StatefulWidget {
  final String title;

  const _ReminderFormScreen({required this.title});

  @override
  State<_ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends State<_ReminderFormScreen> {
  DateTime? _date;
  TimeOfDay? _time;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.pink.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  initialDate: DateTime.now(),
                );
                if (picked != null) setState(() => _date = picked);
              },
              icon: const Icon(Icons.calendar_month),
              label: Text(_date == null ? 'Pick Date' : 'Date: ${_date!.toLocal().toString().split(' ').first}'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                if (picked != null) setState(() => _time = picked);
              },
              icon: const Icon(Icons.access_time),
              label: Text(_time == null ? 'Pick Time' : 'Time: ${_time!.format(context)}'),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('UI only (no notifications set yet)')),
                );
              },
              child: const Text('SET REMINDER'),
            ),
          ],
        ),
      ),
    );
  }
}
