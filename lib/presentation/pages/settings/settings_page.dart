import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/core/constants/app_constants.dart';
import 'package:nubilab/presentation/viewmodels/theme_viewmodel.dart';
import 'package:nubilab/presentation/pages/settings/widgets/theme_selection_dialog.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final themeViewModel = ref.read(themeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          // 테마 설정 섹션
          const _SectionTitle(title: '화면 설정'),
          ListTile(
            title: const Text('테마 모드'),
            subtitle: Text(themeViewModel.getThemeModeName(themeMode)),
            trailing: const Icon(Icons.brightness_6),
            onTap: () => _showThemeDialog(context, ref),
          ),
          const Divider(),

          // 앱 정보 섹션
          const _SectionTitle(title: '앱 정보'),
          ListTile(
            title: const Text('버전'),
            subtitle: Text(
                '${AppConstants.appVersion} (${AppConstants.buildNumber})'),
            trailing: const Icon(Icons.info_outline),
          ),
          ListTile(
            title: const Text('개발자'),
            subtitle: const Text('개발자 이름'),
            trailing: const Icon(Icons.person_outline),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const ThemeSelectionDialog(),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
