import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/constants.dart';
import '../../models/journey_model.dart';
import '../../models/achievement_model.dart';
import 'post_creator_screen.dart';

class AchievementUnlockScreen extends StatefulWidget {
  final JourneyModel journey;
  final List<AchievementModel> unlockedAchievements;

  const AchievementUnlockScreen({
    super.key,
    required this.journey,
    required this.unlockedAchievements,
  });

  @override
  State<AchievementUnlockScreen> createState() => _AchievementUnlockScreenState();
}

class _AchievementUnlockScreenState extends State<AchievementUnlockScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasNewAchievement = widget.unlockedAchievements.isNotEmpty;
    final primaryAchievement =
        hasNewAchievement ? widget.unlockedAchievements.first : null;
    final currentXp = 1240;
    final nextGoalXp = 2000;

    return Scaffold(
      backgroundColor: AppConstants.backgroundDark,
      body: Stack(
        children: [
          // Radial glow background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: _GlowPainter(
                    color: AppConstants.accentGold,
                    scale: _pulseAnimation.value,
                  ),
                );
              },
            ),
          ),

          // Particle effect overlay
          Positioned.fill(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.8,
                    colors: [
                      AppConstants.accentGold.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // "NEW ACHIEVEMENT" Label
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppConstants.accentGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppConstants.accentGold.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        'NEW ACHIEVEMENT',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.accentGold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // "You've reached a new horizon"
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: AnimatedBuilder(
                      animation: _slideAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: child,
                        );
                      },
                      child: Text(
                        "You've reached a\nnew horizon",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppConstants.textPrimary,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Mountain Badge
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppConstants.accentGold.withValues(alpha: 0.3),
                              AppConstants.accentGold.withValues(alpha: 0.05),
                            ],
                          ),
                          border: Border.all(
                            color: AppConstants.accentGold.withValues(alpha: 0.4),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppConstants.accentGold.withValues(alpha: 0.3),
                              blurRadius: 40,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Mountain icon
                              CustomPaint(
                                size: const Size(60, 50),
                                painter: _MountainPainter(
                                  color: AppConstants.accentGold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Achievement Name
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      hasNewAchievement
                          ? primaryAchievement!.name.toUpperCase()
                          : 'SAHARAN EXPLORER',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppConstants.accentGold,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Level & Progress
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppConstants.backgroundCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppConstants.divider),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Your New Rank',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppConstants.textSecondary,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Explorer Level 5',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppConstants.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // XP Progress Bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TOTAL XP',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: AppConstants.textTertiary,
                                  letterSpacing: 1,
                                ),
                              ),
                              Text(
                                'NEXT GOAL',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: AppConstants.textTertiary,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: currentXp / nextGoalXp,
                              minHeight: 8,
                              backgroundColor: AppConstants.backgroundDark,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppConstants.accentTeal,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$currentXp',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppConstants.accentTeal,
                                ),
                              ),
                              Text(
                                '$nextGoalXp',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppConstants.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Share Button
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) =>
                                  PostCreatorScreen(journey: widget.journey),
                            ),
                          );
                        },
                        icon: const Icon(Icons.share, size: 20),
                        label: Text(
                          'SHARE WITH COMMUNITY',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.accentTeal,
                          foregroundColor: AppConstants.backgroundDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Back to Profile
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.person_outline, size: 20),
                        label: Text(
                          'BACK TO PROFILE',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppConstants.textSecondary,
                          side: BorderSide(
                            color: AppConstants.divider,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the radial glow effect
class _GlowPainter extends CustomPainter {
  final Color color;
  final double scale;

  _GlowPainter({required this.color, required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.35);
    final radius = size.width * 0.5 * scale;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.08),
          color.withValues(alpha: 0.02),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _GlowPainter oldDelegate) =>
      oldDelegate.scale != scale;
}

// Custom painter for the mountain/triangle icon
class _MountainPainter extends CustomPainter {
  final Color color;

  _MountainPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Main mountain
    final mainPath = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(mainPath, paint);

    // Snow cap
    final snowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final snowPath = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width * 0.6, size.height * 0.25)
      ..lineTo(size.width * 0.4, size.height * 0.25)
      ..close();

    canvas.drawPath(snowPath, snowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
