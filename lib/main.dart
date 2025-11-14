import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'data/api/spacex.service.dart';
import 'presentation/bloc/favorites/favorites.cubit.dart';
import 'presentation/bloc/launches/launch_list.cubit.dart';
import 'presentation/pages/launch_list.page.dart';
import 'presentation/pages/onboarding.page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(MyApp(seenOnboarding: seenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;

  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LaunchListCubit>(
          create: (context) => LaunchListCubit(
            apiService: SpaceXApiServiceImpl(client: http.Client()),
          )..fetchLaunches(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (context) => FavoritesCubit()..loadFavorites(),
        ),
      ],
      child: MaterialApp(
        title: 'SpaceX App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFF121212),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1F1F1F),
            elevation: 0,
          ),
          colorScheme: const ColorScheme.dark(
            primary: Colors.blueAccent,
            secondary: Colors.blueGrey,
          ),
        ),
        home: seenOnboarding ? const LaunchListPage() : const OnboardingPage(),
      ),
    );
  }
}
