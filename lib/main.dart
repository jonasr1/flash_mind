import 'package:flash_mind/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_scope.dart';
import 'core/progress/controllers/user_progress_controller.dart';
import 'core/progress/repositories/local_user_progress_repository.dart';
import 'core/progress/services/gamification_service.dart';
import 'core/review/review_service.dart';
import 'features/decks/repositories/local_deck_repository.dart';
import 'features/decks/services/deck_service.dart';
import 'features/flashcards/services/spaced_repetition_service.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final prefs = await SharedPreferences.getInstance();

  final deckService = DeckService(repository: LocalDeckRepository(prefs));
  await deckService.init();

  final userProgressController = UserProgressController(
    repository: LocalUserProgressRepository(prefs),
  );
  await userProgressController.init();

  final reviewService = ReviewService(
    spacedRepetitionService: SpacedRepetitionService(),
    gamificationService: const GamificationService(),
    userProgressController: userProgressController,
    deckService: deckService,
  );

  final themeIndex = prefs.getInt('theme_mode');
  final initialThemeMode = themeIndex != null && themeIndex >= 0 && themeIndex < ThemeMode.values.length
      ? ThemeMode.values[themeIndex]
      : ThemeMode.system;

  runApp(
    AppScope(
      deckService: deckService,
      userProgressController: userProgressController,
      reviewService: reviewService,
      child: FlashcardApp(initialThemeMode: initialThemeMode),
    ),
  );
}

class FlashcardApp extends StatefulWidget {
  final ThemeMode initialThemeMode;

  const FlashcardApp({super.key, required this.initialThemeMode});

  static FlashcardAppState of(BuildContext context) =>
      context.findAncestorStateOfType<FlashcardAppState>()!;

  @override
  State<FlashcardApp> createState() => FlashcardAppState();
}

class FlashcardAppState extends State<FlashcardApp> {
  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  Future<void> changeThemeMode(ThemeMode mode) async {
    setState(() {
      _themeMode = mode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6366F1);

    return MaterialApp(
      title: 'FlashMind',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,

      // LIGHT THEME
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,

        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          surface: const Color(0xFFF6F7FB),
          outlineVariant: const Color(0xFFE4E4E7),
        ),

        scaffoldBackgroundColor: const Color(0xFFF6F7FB),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),

        textTheme: const TextTheme(
          displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Color(0xFF09090B),
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF09090B),
          ),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF71717A)),
        ),

        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE4E4E7), width: 1),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 1.5),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(color: Color(0xFFE4E4E7)),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      // DARK THEME
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
          primary: primaryColor,
          surface: const Color(0xFF0F1115),
          outlineVariant: const Color(0xFF27272A),
        ),

        scaffoldBackgroundColor: const Color(0xFF0F1115),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),

        textTheme: const TextTheme(
          displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Color(0xFFFAFAFA),
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFAFAFA),
          ),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFA1A1AA)),
        ),

        cardTheme: CardThemeData(
          color: const Color(0xFF18181B),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF27272A), width: 1),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF18181B),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF27272A)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF27272A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 1.5),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(color: Color(0xFF27272A)),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      home: const HomeScreen(),
    );
  }
}
