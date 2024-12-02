import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'switch_theme_state.dart';

class SwitchThemeCubit extends Cubit<SwitchThemeState> {
  SwitchThemeCubit() : super(const SwitchThemeState(isDarkMode: false)) {
    _loadTheme();
  }

  void toggleTheme() {
    final newTheme = !state.isDarkMode;
    emit(SwitchThemeState(isDarkMode: newTheme));
    _saveTheme(newTheme);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    emit(SwitchThemeState(isDarkMode: isDarkMode));
  }

  Future<void> _saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }
}
