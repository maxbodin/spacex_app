import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacex_app/presentation/pages/launch_list.page.dart';

class OnboardingContent {
  final String title;
  final String description;
  final IconData icon;

  const OnboardingContent({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Content for the onboarding pages.
  final List<OnboardingContent> _content = const [
    OnboardingContent(
      title: 'Welcome to SpaceX App',
      description: 'Explore all the latest and historic launches from SpaceX.',
      icon: Icons.rocket_launch,
    ),
    OnboardingContent(
      title: 'List & Grid Views',
      description:
          'Switch between list and grid views to see launches your way.',
      icon: Icons.view_comfy_alt_outlined,
    ),
    OnboardingContent(
      title: 'Save Your Favorites',
      description: 'Tap the heart icon to save launches you find interesting.',
      icon: Icons.favorite_border,
    ),
  ];

  // Function to run when onboarding is completed.
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LaunchListPage()),
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
              child: PageView.builder(
                controller: _pageController,
                itemCount: _content.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _OnboardingPage(content: _content[index]);
                },
              ),
            ),
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _content.length,
              (index) => _buildPageIndicator(index == _currentPage),
            ),
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage < _content.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } else {
                  _completeOnboarding();
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
              child: Icon(
                _currentPage < _content.length - 1
                    ? Icons.arrow_forward_ios
                    : Icons.check,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blueAccent : Colors.grey.shade600,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingContent content;

  const _OnboardingPage({required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              shape: BoxShape.circle,
            ),
            child: Icon(content.icon, size: 60, color: Colors.blueAccent),
          ),
          const SizedBox(height: 56),
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            content.description,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
