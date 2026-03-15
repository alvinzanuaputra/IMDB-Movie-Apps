import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imdbmoviesapps/Core/App/AppSettings.dart';
import 'package:imdbmoviesapps/Screens/Home/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      // disableNavigation: true,
      backgroundColor: const Color(0xFF0B111B),

      duration: 2000,
      nextScreen: const MyHomePage(),
      splash: Container(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/icons/logo.png'),
                          fit: BoxFit.contain)),
                ),
              ),
              Expanded(
                child: Container(
                  child: const Text(
                    'By Alvin Zanua Putra',
                    style: TextStyle(
                      color: Color(0xFFE5EAF4),
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // splash: Image.asset('assets/images/intro.png'),
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: 200,
      // centered: false,
    );
  }
}
