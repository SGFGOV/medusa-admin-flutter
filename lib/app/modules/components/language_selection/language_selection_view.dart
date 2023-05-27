import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../data/service/language_service.dart';
import 'language_locale.dart';

class LanguageSelectionView extends StatelessWidget {
  const LanguageSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
            ),
            child: Text('Select App Language'),
          ),
          Divider(
            height: 0,
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AppLocalizations.supportedLocales.length,
            itemBuilder: (context, index) {
              final languageLocale = AppLocalizations.supportedLocales[index];
              final languageName = LanguageLocal()
                  .getDisplayLanguage(languageLocale.languageCode)
                  .name;
              final languageNativeName = LanguageLocal()
                  .getDisplayLanguage(languageLocale.languageCode)
                  .nativeName;
              return RadioListTile<String>(
                value: languageLocale.languageCode,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(languageName),
                    if (languageName != languageNativeName)
                      Text(languageNativeName),
                  ],
                ),
                groupValue: LanguageService.language,
                onChanged: (val) async {
                  if (val == null) {
                    return;
                  }
                  await LanguageService.instance.changeLanguage(val);
                  Get.back();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
