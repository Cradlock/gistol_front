import 'package:app_front/core/strings.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:app_front/features/settings/settings.dart';
import 'package:app_front/features/tasks/view/widgets/task_history_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _initials(User user) {
    final surname = user.surname?.trim() ?? '';
    final name = user.name?.trim() ?? '';
    final letters =
        '${surname.isNotEmpty ? surname[0] : ''}'
        '${name.isNotEmpty ? name[0] : ''}';
    return letters.toUpperCase();
  }

  void _openTaskHistory(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: colors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const SafeArea(child: TaskHistorySheet()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final fullName = '${user.surname ?? ''} ${user.name ?? ''}'.trim();

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: colors.primaryContainer,
                foregroundColor: colors.onPrimaryContainer,
                child: Text(
                  _initials(user).isEmpty ? '?' : _initials(user),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                fullName.isEmpty ? '—' : fullName,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                color: colors.surfaceContainerLow,
                child: Column(
                  children: [
                    _ProfileFact(
                      icon: Icons.school_outlined,
                      label: AppStrings.profile.year.tr(),
                      value: '${user.year ?? '—'}',
                    ),
                    Divider(height: 1, color: colors.outlineVariant),
                    _ProfileFact(
                      icon: Icons.groups_outlined,
                      label: AppStrings.profile.group.tr(),
                      value: user.group?.title ?? '—',
                    ),
                    Divider(height: 1, color: colors.outlineVariant),
                    _ProfileFact(
                      icon: Icons.stars_outlined,
                      label: AppStrings.profile.scores.tr(),
                      value: '${user.scores ?? 0}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                color: colors.surfaceContainerLow,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.settings_outlined,
                        color: colors.onSurfaceVariant,
                      ),
                      title: Text(AppStrings.profile.settings.tr()),
                      onTap: () => showSettingsOverlay(context),
                    ),
                    Divider(height: 1, color: colors.outlineVariant),
                    ListTile(
                      leading: Icon(Icons.logout, color: colors.error),
                      title: Text(
                        AppStrings.profile.logout.tr(),
                        style: TextStyle(color: colors.error),
                      ),
                      onTap: () => context.read<AuthProvider>().logout(),
                    ),
                    Divider(height: 1, color: colors.outlineVariant),
                    ListTile(
                      leading: Icon(
                        Icons.history_edu_outlined,
                        color: colors.onSurfaceVariant,
                      ),
                      title: Text(AppStrings.profile.taskHistory.tr()),
                      onTap: () => _openTaskHistory(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileFact extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileFact({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: Text(
        value,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
