import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:neighborhub/firebase_options.dart';
import 'package:neighborhub/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:neighborhub/user/dashboarduser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeighborHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF6C63FF),
          secondary: const Color(0xFF6C63FF),
          background: const Color(0xFF1A1A1A),
          surface: const Color(0xFF2D2D2D),
        ),
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2D2D2D),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelStyle: const TextStyle(color: Colors.grey),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Color(0xFF1A1A1A),
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
                ),
              ),
            );
          }
          
          if (snapshot.hasData) {
            return const DashboardUser();
          }
          
          return const LoginPage();
        },
      ),
    );
  }
}
