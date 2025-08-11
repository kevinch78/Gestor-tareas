import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/api_service.dart';
import '../../core/token_storage.dart';

// Proveedor de TokenStorage (singleton)
final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

// Proveedor de ApiService (se puede leer y luego setear token)
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
