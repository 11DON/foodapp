import 'package:f3/components/language_constants.dart';
import 'package:f3/components/languages.dart';
import 'package:f3/generated/l10n.dart';
import 'package:f3/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:f3/lib/10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  Locale currnetLocale = const Locale('en');

  void onLanguageChange() {
    currnetLocale =
        currnetLocale.languageCode == 'ar' ? Locale('en') : Locale('ar');
  }

  void onThemeChange() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              ListTile(
                  title: Text('language'),
                  trailing: DropdownButton<Language>(
                      underline: SizedBox(),
                      icon: Icon(
                        Icons.language,
                        color: Colors.black,
                      ),
                      onChanged: (Language? language)async {
                        Locale _locale = await setLocale(language!.Languagecode);
                        MyApp.setLocale(context,_locale);
                                          },
                      items: Language.languageList()
                          .map<DropdownMenuItem<Language>>(
                            (e) => DropdownMenuItem<Language>(
                              value: e,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(e.name),
        
                                ],
                              ),
                            ),
                          )
                          .toList()))
            ],
          ),
        ),
      ),
    );
  }
}
