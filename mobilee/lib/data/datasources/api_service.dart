import 'package:dio/dio.dart';
import '../../core/constants.dart';
import '../models/task_model.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class ApiService {
  final Dio _dio;
  final String _baseUrl = baseUrl;

  ApiService() : _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _dio.options.headers['Authorization']?.toString().replaceAll('Bearer ', '');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          throw AuthException('Sesión expirada. Por favor, inicia sesión nuevamente.');
        }
        print('Error: ${e.response?.statusCode} - ${e.message}');
        return handler.next(e);
      },
    ));
  }

  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearToken() {
    _dio.options.headers.remove('Authorization');
  }

  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await _dio.get('/tasks');
      return (response.data as List).map((e) => TaskModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        throw AuthException('Sesión expirada');
      }
      throw Exception('Failed to load tasks: $e');
    }
  }

  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {'email': email, 'password': password});
      return response.data['access_token'] ?? response.data['token'] as String;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<String> register(String email, String password) async {
    try {
      final response = await _dio.post('/auth/register', data: {'email': email, 'password': password});
      return response.data['access_token'] ?? response.data['token'] as String;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<TaskModel> createTask(String title, String? description) async {
    try {
      final response = await _dio.post('/tasks', data: {'title': title, 'description': description});
      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        throw AuthException('Sesión expirada');
      }
      throw Exception('Failed to create task: $e');
    }
  }

  Future<TaskModel> updateTask(String id, Map<String, dynamic> changes) async {
    try {
      final response = await _dio.patch('/tasks/$id', data: changes);
      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        throw AuthException('Sesión expirada');
      }
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _dio.delete('/tasks/$id');
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        throw AuthException('Sesión expirada');
      }
      throw Exception('Failed to delete task: $e');
    }
  }
}