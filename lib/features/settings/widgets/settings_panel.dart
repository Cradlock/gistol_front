import 'package:app_front/core/strings.dart';
import 'package:app_front/features/settings/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showSettingsOverlay(BuildContext context) {
  final colors = Theme.of(context).colorScheme;

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: colors.surfaceContainerLow,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16 + MediaQuery.paddingOf(context).bottom,
        ),
        child: const SettingsPanel(showTitle: true),
      );
    },
  );
}

class SettingsPanel extends StatelessWidget {
  final bool showTitle;

  const SettingsPanel({super.key, this.showTitle = false});

  void _showLangDialog(BuildContext context) {
    final settingsProvider = context.read<SettingsProvider>();
    final List<Locale> supported = context.supportedLocales;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: supported.map((locale) {
              final String code = locale.languageCode;
              final Map<String, String>? details =
                  SettingsProvider.langDetails[code];
              final String name = details?['name'] ?? code.toUpperCase();
              final String flag = details?['flag'] ?? 'assets/nothing.png';
              final bool isSelected = context.locale.languageCode == code;

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    flag,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                  ),
                ),
                trailing: isSelected ? const Icon(Icons.check) : null,
                title: Text(name),
                onTap: () {
                  settingsProvider.changeLanguage(context, locale);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final String currentCode = context.locale.languageCode;
    final String currentLanguageName =
        SettingsProvider.langDetails[currentCode]?['name'] ??
            currentCode.toUpperCase();
    final colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            child: Text(
              AppStrings.settings.title.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          color: colors.surfaceContainerHighest,
          child: Column(
            children: [
              SwitchListTile(
                title: Text(AppStrings.settings.darkmode.tr()),
                secondary: Icon(
                  settingsProvider.isDarkMode
                      ? Icons.dark_mode
                      : Icons.light_mode_outlined,
                ),
                value: settingsProvider.isDarkMode,
                onChanged: settingsProvider.toggleTheme,
              ),
              ListTile(
                title: Text(AppStrings.settings.langmode.tr()),
                leading: const Icon(Icons.language),
                trailing: Text(
                  currentLanguageName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () => _showLangDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
