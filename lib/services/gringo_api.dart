import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider definition
final gringoApiProvider = Provider((ref) => GringoApiService());

class GringoApiService {
  // TODO: Replace with your actual n8n webhook URL
  final String _baseUrl = 'https://n8n.example.com/webhook/gringo';
  final String _apiKey = 'your-secret-key';
  
  // Toggle this to true to test UI without a backend
  final bool _mockMode = true;

  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String fullName,
  }) async {
    if (_mockMode) {
      await Future.delayed(const Duration(seconds: 1)); // Simulate latency
      return {
        'user_id': 'mock-uuid-1234',
        'email': email,
        'full_name': fullName,
        'status': 'success'
      };
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/user/register'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'full_name': fullName,
        'timezone': DateTime.now().timeZoneName,
      }),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getPersonalization({
    required String userId,
    required int painLevel,
    required int energyLevel,
    int timeAvailable = 15,
  }) async {
    if (_mockMode) {
      await Future.delayed(const Duration(seconds: 2));
      return {
        'recommendation_id': 'rec-5678',
        'movements': [1, 2, 5, 8, 12], // Sequence numbers
        'message': 'Based on your pain level of $painLevel, let\'s focus on gentle flow.',
      };
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/ai/personalize'),
      headers: _headers,
      body: jsonEncode({
        'user_id': userId,
        'pain_level': painLevel,
        'energy_level': energyLevel,
        'time_available': timeAvailable,
      }),
    );

    return _handleResponse(response);
  }

  Future<void> logSession({
    required String userId,
    required DateTime startedAt,
    required int durationSeconds,
    required List<int> movementsCompleted,
    int? prePain,
    int? postPain,
    int? preEnergy,
    int? postEnergy,
    String? notes,
  }) async {
    if (_mockMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return;
    }

    await http.post(
      Uri.parse('$_baseUrl/session/complete'),
      headers: _headers,
      body: jsonEncode({
        'user_id': userId,
        'started_at': startedAt.toIso8601String(),
        'duration_seconds': durationSeconds,
        'movements_completed': movementsCompleted,
        'pre_pain_level': prePain,
        'post_pain_level': postPain,
        'pre_energy_level': preEnergy,
        'post_energy_level': postEnergy,
        'notes': notes,
      }),
    );
  }

  Future<String> chatWithOrchestrator({
    required String userId,
    required String message,
  }) async {
    if (_mockMode) {
      await Future.delayed(const Duration(seconds: 1));
      return "I understand you're feeling some tension. Let's try some 'Dead Arms' to release that shoulder stress.";
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/ai/orchestrator'),
      headers: _headers,
      body: jsonEncode({
        'user_id': userId,
        'message': message,
      }),
    );

    final data = _handleResponse(response);
    return data['response'] ?? 'No response';
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_apiKey',
  };

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}
