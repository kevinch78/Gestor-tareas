import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/api_service.dart';
import '../../core/token_storage.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
