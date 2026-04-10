import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/constants.dart';
import 'home_screen.dart';
import 'gamification/social_feed_screen.dart';
import 'gamification/leaderboard_screen.dart';
import 'gamification/explorer_profile_screen.dart';
import 'gamification/journey_tracker_screen.dart'; // We'll keep tracker but maybe wrap it in safety

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 1; // Default to Planner

  final List<Widget> _screens = [
    const SocialFeedScreen(),
    const HomeScreen(),
    const JourneyTrackerScreen(), // Live Tracking & Safety Center
    const ExplorerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppConstants.backgroundDark,
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppConstants.backgroundCard,
            border: Border(top: BorderSide(color: AppConstants.divider.withValues(alpha: 0.5))),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.people_outline, Icons.people, 'Community'),
                  _buildNavItem(1, Icons.auto_awesome_outlined, Icons.auto_awesome, 'AI Plan'),
                  _buildNavItem(2, Icons.security_outlined, Icons.security, 'Safety'),
                  _buildNavItem(3, Icons.person_outline, Icons.person, 'Profile'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.accentTeal.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 22,
              color: isSelected ? AppConstants.accentTeal : AppConstants.textTertiary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppConstants.accentTeal : AppConstants.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
