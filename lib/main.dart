import 'package:f3/Auth.dart';
import 'package:f3/Pages/products_page.dart';
import 'package:f3/Pages/login_page.dart';
import 'package:f3/components/navigation_bar.dart';
import 'package:f3/Provider/cart_model.dart';
import 'package:f3/components/language_constants.dart';
import 'package:f3/components/main_wrapper.dart';
import 'package:f3/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CartModel()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context,Locale newLocale){
    _MyAppState? state=context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale){
    setState(() {
      _locale=locale;
    });
  }
  @override
  void didChangeDependencies() {
    getLocale().then((locale)=> setLocale(locale));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      home: const SplashScreen(),
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginPage(),
        'home': (context) => const ProductsPage(),
        '/main':(context)=>const MainWrapper(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const ProductsPage());
      },
    );
  }
}
