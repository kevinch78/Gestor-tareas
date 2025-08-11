import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/api_provider.dart';
import 'tasks_page.dart';
import '../../core/constants.dart'; 

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (loading) return;
    setState(() => loading = true);
    final api = ref.read(apiServiceProvider);
    final tokenStorage = ref.read(tokenStorageProvider);

    try {
      final token = await api.register(emailController.text.trim(), passwordController.text.trim());
      await tokenStorage.saveToken(token);
      api.setToken(token);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TasksPage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e', style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red[700],
        ),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_add, size: 80, color: AppConstants.primaryColor),
                const SizedBox(height: 20),
                Text(
                  'Crear Cuenta',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppConstants.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email', hintText: 'tu@email.com'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Contraseña', hintText: '••••••••'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _register,
                  child: loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Crear Cuenta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}