import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'launch_list.page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LaunchListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: const [
                  _OnboardingPage(
                    icon: Icons.rocket_launch,
                    title: 'Welcome to SpaceX App',
                    description:
                        'Explore all the latest and historic launches from SpaceX.',
                  ),
                  _OnboardingPage(
                    icon: Icons.view_list,
                    title: 'List & Grid Views',
                    description:
                        'Switch between list and grid views to see launches your way.',
                  ),
                  _OnboardingPage(
                    icon: Icons.favorite,
                    title: 'Save Your Favorites',
                    description:
                        'Tap the heart icon to save launches you find interesting.',
                  ),
                ],
              ),
            ),
            if (_currentPage == 2)
              ElevatedButton(
                onPressed: _completeOnboarding,
                child: const Text('Get Started'),
              )
            else
              TextButton(
                onPressed: _completeOnboarding,
                child: const Text('Skip'),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingPage({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Colors.blueAccent),
          const SizedBox(height: 48),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
