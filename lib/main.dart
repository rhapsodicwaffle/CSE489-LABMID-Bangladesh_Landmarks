import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/map_screen.dart';
import 'screens/records_screen.dart';
import 'screens/landmark_form_screen.dart';
import 'providers/landmark_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LandmarkProvider()),
      ],
      child: MaterialApp(
        title: 'Bangladesh Landmarks',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00F0FF), // Neon cyan
            secondary: Color(0xFFFF006E), // Neon pink
            tertiary: Color(0xFFFFEA00), // Neon yellow
            surface: Color(0xFF0D0221), // Deep purple-black
            background: Color(0xFF0A0118), // Very dark purple
            error: Color(0xFFFF006E),
            onPrimary: Color(0xFF0A0118),
            onSecondary: Color(0xFF0A0118),
            onSurface: Color(0xFF00F0FF),
            onBackground: Color(0xFF00F0FF),
          ),
          scaffoldBackgroundColor: const Color(0xFF0A0118),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Color(0xFF0D0221),
            foregroundColor: Color(0xFF00F0FF),
            iconTheme: IconThemeData(color: Color(0xFF00F0FF)),
          ),
          cardTheme: const CardThemeData(
            color: Color(0xFF0D0221),
            elevation: 8,
            shadowColor: Color(0xFF00F0FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              side: BorderSide(color: Color(0xFF00F0FF), width: 1),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Color(0xFF0D0221),
            labelStyle: TextStyle(color: Color(0xFF00F0FF)),
            hintStyle: TextStyle(color: Color(0xFF6B4D87)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: Color(0xFF00F0FF), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: Color(0xFF6B4D87), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: Color(0xFF00F0FF), width: 2),
            ),
            prefixIconColor: Color(0xFF00F0FF),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00F0FF),
              foregroundColor: const Color(0xFF0A0118),
              shadowColor: const Color(0xFF00F0FF),
              elevation: 8,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF00F0FF),
              side: const BorderSide(color: Color(0xFF00F0FF), width: 2),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF0D0221),
            selectedItemColor: Color(0xFF00F0FF),
            unselectedItemColor: Color(0xFF6B4D87),
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            type: BottomNavigationBarType.fixed,
          ),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(color: Color(0xFF00F0FF), fontWeight: FontWeight.bold, letterSpacing: 2),
            headlineMedium: TextStyle(color: Color(0xFF00F0FF), fontWeight: FontWeight.bold, letterSpacing: 1.5),
            bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
            bodyMedium: TextStyle(color: Color(0xFFB0B0B0)),
          ),
          iconTheme: const IconThemeData(color: Color(0xFF00F0FF)),
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    MapScreen(),
    RecordsScreen(),
    LandmarkFormScreen(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_location),
            label: 'New Entry',
          ),
        ],
      ),
    );
  }
}
