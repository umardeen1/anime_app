import 'package:anime_app/pages/home.dart';
import 'package:anime_app/pages/new_release_page.dart';
import 'package:anime_app/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/api_service.dart';
import 'bloc/anime_bloc.dart';

void main() {
  runApp(const AnimeHub());
}

class AnimeHub extends StatelessWidget {
  const AnimeHub({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // App load hote hi data fetch karne ke liye
      create: (context) => AnimeBloc(ApiService())..add(FetchAnimeData()),
      child: MaterialApp(
        title: 'Anime Hub',
        debugShowCheckedModeBanner: false, // Debug banner hatane ke liye
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: Colors.black,
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

  // IMPORTANT: Is list ko yahan sahi se declare karna zaroori hai
  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const NewReleasesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Yahan _pages use ho raha hai
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed, // Saare icons dikhane ke liye
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'New Releases',
          ),
        ],
      ),
    );
  }
}
