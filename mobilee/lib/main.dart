import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/tasks_page.dart';
import 'presentation/providers/api_provider.dart';
import 'core/token_storage.dart';

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
      api.setToken(token); // Setea el token para las peticiones
      return const TasksPage();
    }
    return const LoginPage();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Gestor de Tareas',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Usamos home para decidir dinámicamente
      home: FutureBuilder<Widget>(
        future: _determineStartWidget(ref),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data!;
        },
      ),
      // Solo rutas adicionales, sin "/"
      routes: {
        '/tasks': (_) => const TasksPage(),
      },
    );
  }
}
