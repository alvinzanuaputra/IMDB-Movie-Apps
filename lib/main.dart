import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:imdbmoviesapps/Core/App/AppSettings.dart';
import 'package:imdbmoviesapps/Screens/Home/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:imdbmoviesapps/firebase_options.dart';

// tambahan untuk firebase

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppSettings.initialize();
  SharedPreferences sp = await SharedPreferences.getInstance();
  String imagepath = sp.getString('imagepath') ?? '';
  runApp(MyApp(
    imagepath: imagepath,
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //     overlays: [SystemUiOverlay.bottom]);
}

class MyApp extends StatelessWidget {
  String imagepath;
  MyApp({
    super.key,
    required this.imagepath,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'zanuamovie',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFF6A3D),
        scaffoldBackgroundColor: const Color(0xFF0B111B),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B111B),
          foregroundColor: Color(0xFFF7F8FA),
          elevation: 0,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF6A3D),
          secondary: Color(0xFF35B6FF),
          surface: Color(0xFF131D2B),
          onPrimary: Color(0xFFFAFBFF),
          onSurface: Color(0xFFE5EAF4),
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const intermediatescreen(),
    );
  }
}

class intermediatescreen extends StatefulWidget {
  const intermediatescreen({super.key});

  @override
  State<intermediatescreen> createState() => _intermediatescreenState();
}

class _intermediatescreenState extends State<intermediatescreen> {
  static const Duration _splashDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    Timer(_splashDuration, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const MyHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B111B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const Text(
              'By Alvin Zanua Putra',
              style: TextStyle(
                color: Color(0xFFE5EAF4),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
