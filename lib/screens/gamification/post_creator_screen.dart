import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../models/journey_model.dart';
import '../../models/post_model.dart';
import '../../providers/user_provider.dart';
import '../../providers/feed_provider.dart';

class PostCreatorScreen extends StatefulWidget {
  final JourneyModel journey;

  const PostCreatorScreen({super.key, required this.journey});

  @override
  State<PostCreatorScreen> createState() => _PostCreatorScreenState();
}

class _PostCreatorScreenState extends State<PostCreatorScreen> {
  late TextEditingController _captionController;
  bool _isGeneratingAI = false;

  @override
  void initState() {
    super.initState();
    final defaultCaption = "استكشفت ${widget.journey.placeName} اليوم! مسار رائع بمسافة ${widget.journey.distanceKm.toStringAsFixed(1)} كم في ${widget.journey.duration.inMinutes} دقيقة. منظر لا يُنسى ⛰️🇩🇿";
    
    _captionController = TextEditingController(text: defaultCaption);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundWhite,
      appBar: AppBar(
        title: Text('إنشاء منشور', style: GoogleFonts.cairo(fontWeight: FontWeight.w800, color: AppConstants.primaryGreen)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppConstants.textDark),
        actions: [
          TextButton(
            onPressed: _publishPost,
            child: Text(
              'انشر',
              style: GoogleFonts.cairo(color: AppConstants.primaryGreen, fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Preview Slot
            Container(
              width: double.infinity,
              height: 300,
              color: AppConstants.backgroundCream,
              child: widget.journey.photos.isNotEmpty
                  ? Image.file(
                      File(widget.journey.photos.first),
                      fit: BoxFit.cover,
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 60, color: AppConstants.textMedium),
                          SizedBox(height: 8),
                          Text('اضغط لإضافة صورة من مسارك'),
                        ],
                      ),
                    ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Caption Editor
                  TextField(
                    controller: _captionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'اكتب تعليقاً...',
                      hintStyle: GoogleFonts.cairo(color: AppConstants.textLight),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppConstants.divider),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppConstants.primaryGreen, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // AI Auto Caption Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isGeneratingAI = true;
                          // Mock AI Request
                          Future.delayed(const Duration(seconds: 2), () {
                            if (!mounted) return;
                            setState(() {
                              _captionController.text = "يا خاوتي اليوم درت مسار مهبول في ${widget.journey.placeName}! ضربت ${widget.journey.distanceKm.toStringAsFixed(1)} كيلومتر وريحت المخ. الطبيعة تاع بلادنا وحدها 😍🔥🇩🇿 #اكتشف_الجزائر #رحلة";
                              _isGeneratingAI = false;
                            });
                          });
                        });
                      },
                      icon: _isGeneratingAI 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.auto_awesome, color: AppConstants.accentGoldDark),
                      label: Text(
                        'توليد زكارة بالذكاء الاصطناعي (Groq)',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Journey Auto Stats
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryGreen.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(Icons.route, '${widget.journey.distanceKm.toStringAsFixed(1)} كم'),
                        _buildStat(Icons.timer, '${widget.journey.duration.inMinutes} دقيقة'),
                        _buildStat(Icons.terrain, widget.journey.difficulty),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String val) {
    return Column(
      children: [
        Icon(icon, color: AppConstants.primaryGreen),
        const SizedBox(height: 4),
        Text(val, style: GoogleFonts.cairo(fontWeight: FontWeight.w700)),
      ],
    );
  }

  void _publishPost() {
    final user = Provider.of<UserProvider>(context, listen: false).currentUser!;
    
    // Create new post
    final newPost = PostModel(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      userId: user.id,
      username: user.username,
      wilayaBadge: user.wilaya,
      journeyId: widget.journey.id,
      photoUrl: '', // Mocked for now
      caption: _captionController.text,
      tags: ['#رحلة', '#الجزائر'],
      createdAt: DateTime.now(),
      distanceKm: widget.journey.distanceKm,
      time: widget.journey.duration,
      difficulty: widget.journey.difficulty,
    );
    
    Provider.of<FeedProvider>(context, listen: false).addPost(newPost);
    Navigator.of(context).pop();
  }
}
