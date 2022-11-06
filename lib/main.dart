import 'package:appointment_scheduler_flutterweb/backend/handler.dart';
import 'package:appointment_scheduler_flutterweb/frontend/availabilities_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(AppointmentSchedulerApp());
}

class AppointmentSchedulerApp extends StatelessWidget {
  AppointmentSchedulerApp({super.key});
  final ThemeData theme = ThemeData();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Handler(),
        ),
      ],
      child: MaterialApp(
        title: 'Appointment Scheduler App',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          colorScheme:
              theme.colorScheme.copyWith(secondary: Colors.indigoAccent),
        ),
        home: AvailabilitiesScreen(),
      ),
    );
  }
}
