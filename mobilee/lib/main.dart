import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/tasks_page.dart';
import 'presentation/pages/register_page.dart';
import 'presentation/providers/api_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  Future<Widget> _determineStartWidget(WidgetRef ref) async {
    final tokenStorage = ref.read(tokenStorageProvider);
    final api = ref.read(apiServiceProvider);
    final token = await tokenStorage.getToken();

    if (token != null) {
      api.setToken(token);
      try {
        await api.getTasks();
        return const TasksPage();
      } catch (e) {
        await tokenStorage.deleteToken();
        api.clearToken();
      }
    }
    return const LoginPage();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestor de Tareas RPG',
      theme: ThemeData(
        primaryColor: const Color(0xFF00D4FF), 
        colorScheme: const ColorScheme.dark()
            .copyWith(primary: const Color(0xFF00D4FF), secondary: const Color(0xFF00FF00)), // Verde neón
        scaffoldBackgroundColor: const Color(0xFF1A1A2E), 
        textTheme: GoogleFonts.orbitronTextTheme( 
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00D4FF),
            foregroundColor: Colors.black,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, 
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            elevation: 8, 
          ).copyWith(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (states) => states.contains(MaterialState.pressed)
                  ? const Color(0xFF00FF00) 
                  : null,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF00FF00), width: 2),
            borderRadius: BorderRadius.zero,
          ),
          filled: true,
          fillColor: const Color(0xFF16213E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF16213E),
          titleTextStyle: TextStyle(color: Color(0xFF00D4FF), fontSize: 24, fontWeight: FontWeight.bold),
          elevation: 10,
        ),
      ),
      home: FutureBuilder<Widget>(
        future: _determineStartWidget(ref),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Color(0xFF00D4FF))),
            );
          }
          return snapshot.data!;
        },
      ),
      routes: {
        '/tasks': (_) => const TasksPage(),
        '/register': (_) => const RegisterPage(),
      },
    );
  }
}