import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// User State Model
class UserState {
  final String? userId;
  final String? fullName;
  final bool isAuthenticated;

  UserState({this.userId, this.fullName, this.isAuthenticated = false});

  UserState copyWith({String? userId, String? fullName, bool? isAuthenticated}) {
    return UserState(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// User Notifier
class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final fullName = prefs.getString('full_name');

    if (userId != null) {
      state = UserState(
        userId: userId,
        fullName: fullName,
        isAuthenticated: true,
      );
    }
  }

  Future<void> login(String userId, String fullName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
    await prefs.setString('full_name', fullName);

    state = UserState(
      userId: userId,
      fullName: fullName,
      isAuthenticated: true,
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = UserState(isAuthenticated: false);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
