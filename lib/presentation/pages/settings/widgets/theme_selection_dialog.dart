import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../viewmodels/theme_viewmodel.dart';

class ThemeSelectionDialog extends ConsumerWidget {
  const ThemeSelectionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeProvider);
    ref.read(themeProvider.notifier);

    return AlertDialog(
      title: const Text('테마 설정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildThemeOption(
            context: context,
            title: '시스템 설정',
            icon: Icons.brightness_auto,
            themeMode: ThemeMode.system,
            currentThemeMode: currentThemeMode,
            onTap: () => _updateThemeMode(ref, ThemeMode.system, context),
          ),
          _buildThemeOption(
            context: context,
            title: '라이트 모드',
            icon: Icons.brightness_5,
            themeMode: ThemeMode.light,
            currentThemeMode: currentThemeMode,
            onTap: () => _updateThemeMode(ref, ThemeMode.light, context),
          ),
          _buildThemeOption(
            context: context,
            title: '다크 모드',
            icon: Icons.brightness_4,
            themeMode: ThemeMode.dark,
            currentThemeMode: currentThemeMode,
            onTap: () => _updateThemeMode(ref, ThemeMode.dark, context),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('닫기'),
        ),
      ],
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required ThemeMode themeMode,
    required ThemeMode currentThemeMode,
    required VoidCallback onTap,
  }) {
    final isSelected = themeMode == currentThemeMode;

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: onTap,
      selected: isSelected,
    );
  }

  void _updateThemeMode(
      WidgetRef ref, ThemeMode themeMode, BuildContext context) {
    ref.read(themeProvider.notifier).setThemeMode(themeMode);
    Navigator.of(context).pop();
  }
}
