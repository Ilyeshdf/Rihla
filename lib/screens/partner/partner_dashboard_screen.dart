import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/constants.dart';
import 'partner_bookings_screen.dart';
import 'partner_listing_screen.dart';

class PartnerDashboardScreen extends StatelessWidget {
  const PartnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppConstants.backgroundWhite,
        appBar: AppBar(
          backgroundColor: AppConstants.primaryGreen,
          title: Text(
            'لوحة الشريك',
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppConstants.primaryGreen,
                      AppConstants.primaryGreenLight,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.primaryGreen.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'نظرة عامة',
                      style: GoogleFonts.cairo(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'إحصائيات نشاطك التجاري',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stats cards
              Row(
                children: [
                  _buildStatCard(
                    icon: Icons.bookmark_added,
                    label: 'إجمالي الحجوزات',
                    value: '12',
                    color: AppConstants.primaryGreen,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    icon: Icons.visibility,
                    label: 'المشاهدات هذا الأسبوع',
                    value: '87',
                    color: const Color(0xFF1976D2),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatCard(
                    icon: Icons.star,
                    label: 'التقييم',
                    value: '4.6',
                    color: AppConstants.accentGold,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    icon: Icons.trending_up,
                    label: 'نسبة التحويل',
                    value: '14%',
                    color: AppConstants.success,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Recent bookings
              Text(
                'آخر الحجوزات',
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.textDark,
                ),
              ),
              const SizedBox(height: 16),
              _buildRecentBooking(
                name: 'أحمد بن علي',
                place: 'فندق الأوراسي',
                date: '2026/04/15',
                status: 'جديد',
              ),
              _buildRecentBooking(
                name: 'فاطمة الزهراء',
                place: 'مطعم دار الجلد',
                date: '2026/04/12',
                status: 'مؤكد',
              ),
              _buildRecentBooking(
                name: 'يوسف حمادي',
                place: 'القصبة',
                date: '2026/04/10',
                status: 'مؤكد',
              ),
              const SizedBox(height: 28),

              // Navigation buttons
              _buildNavButton(
                context,
                icon: Icons.list_alt,
                title: 'طلبات الحجز',
                subtitle: 'إدارة طلبات الحجز الواردة',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PartnerBookingsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildNavButton(
                context,
                icon: Icons.store,
                title: 'ملفي التجاري',
                subtitle: 'تعديل معلومات نشاطك',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PartnerListingScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppConstants.textDark,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: AppConstants.textMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentBooking({
    required String name,
    required String place,
    required String date,
    required String status,
  }) {
    final isNew = status == 'جديد';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppConstants.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person,
              color: AppConstants.primaryGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppConstants.textDark,
                  ),
                ),
                Text(
                  '$place • $date',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: AppConstants.textMedium,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isNew
                  ? AppConstants.accentGold.withValues(alpha: 0.15)
                  : AppConstants.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isNew ? AppConstants.accentGoldDark : AppConstants.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppConstants.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppConstants.primaryGreen, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.textDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: AppConstants.textMedium,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppConstants.textLight,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
