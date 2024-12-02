part of 'switch_theme_cubit.dart';

class SwitchThemeState extends Equatable {
  final bool isDarkMode;

  const SwitchThemeState({required this.isDarkMode});

  @override
  List<Object?> get props => [isDarkMode];
}
