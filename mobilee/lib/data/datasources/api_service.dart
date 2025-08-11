import 'package:dio/dio.dart';
import '../../core/constants.dart';
import '../models/task_model.dart';

class ApiService {
  final Dio _dio;

  ApiService({String? base}) : _dio = Dio(BaseOptions(baseUrl: base ?? baseUrl)) {
    // puedes agregar interceptores de logging aquí (solo en dev)
  }

  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearToken() {
    _dio.options.headers.remove('Authorization');
  }

  // AUTH
  Future<String> login(String email, String password) async {
    final resp = await _dio.post('/auth/login', data: {'email': email, 'password': password});
    // Dependiendo de tu API el campo puede llamarse access_token o token
    return resp.data['access_token'] ?? resp.data['token'];
  }

  Future<String> register(String email, String password) async {
    final resp = await _dio.post('/auth/register', data: {'email': email, 'password': password});
    return resp.data['access_token'] ?? resp.data['token'];
  }

  // TASKS
  Future<List<TaskModel>> getTasks() async {
    final resp = await _dio.get('/tasks');
    final data = List<Map<String, dynamic>>.from(resp.data);
    return data.map((e) => TaskModel.fromJson(e)).toList();
  }



  Future<TaskModel> createTask(String title, String? description) async {
    final resp = await _dio.post('/tasks', data: {'title': title, 'description': description});
    return TaskModel.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<TaskModel> updateTask(int id, Map<String, dynamic> changes) async {
    final resp = await _dio.patch('/tasks/$id', data: changes);
    return TaskModel.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<void> deleteTask(int id) async {
    await _dio.delete('/tasks/$id');
  }
}
