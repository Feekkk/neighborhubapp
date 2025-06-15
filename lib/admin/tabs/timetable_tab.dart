import 'package:flutter/material.dart';
import '../pages/add_event.dart';
import '../pages/add_assign.dart';

class TimetableTab extends StatefulWidget {
  const TimetableTab({super.key});

  @override
  State<TimetableTab> createState() => _TimetableTabState();
}

class _TimetableTabState extends State<TimetableTab> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF232323),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: Colors.white24, width: 1.2),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                    surface: const Color(0xFF232323),
                    onSurface: Colors.white,
                    primary: Theme.of(context).primaryColor,
                  ),
                  textTheme: Theme.of(context).textTheme.copyWith(
                    bodyMedium: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ), dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF232323)),
                ),
                child: CalendarDatePicker(
                  initialDate: _focusedDay,
                  firstDate: DateTime(DateTime.now().year - 1),
                  lastDate: DateTime(DateTime.now().year + 2),
                  onDateChanged: (date) {
                    setState(() {
                      _focusedDay = date;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    'Add Event',
                    Icons.event,
                    Colors.blue,
                    () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddEvent()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionCard(
                    context,
                    'Assign Member',
                    Icons.person_add,
                    Colors.green,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddAssign()),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.7),
                color,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 