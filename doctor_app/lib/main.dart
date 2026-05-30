import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yafszzizbuojzdtvoprh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlhZnN6eml6YnVvanpkdHZvcHJoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk2MjIwMzIsImV4cCI6MjA5NTE5ODAzMn0.U04l8OCMwm-2BXw8gE1gUMR5F7qUv-NhlfFcVM5etno',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppointmentsPage(),
    );
  }
}

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: FutureBuilder(
        future: supabase
            .from('appointments')
            .select()
            .order('created_at', ascending: false),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final appointments = snapshot.data as List;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    appointment['patient_name'] ?? '',
                  ),
                  subtitle: Text(
                    '${appointment['doctor']} • ${appointment['appointment_date']} • ${appointment['appointment_time']}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}