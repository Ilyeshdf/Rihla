import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';

class FeedProvider extends ChangeNotifier {
  List<PostModel> _posts = [];
  bool _isLoading = true;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;

  FeedProvider() {
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    // Better, more reliable Unsplash URLs
    _posts = [
      PostModel(
        id: '1',
        userId: 'm1',
        username: 'Yazid_19',
        wilayaBadge: 'بجاية',
        journeyId: 'j1',
        photoUrl: 'https://images.unsplash.com/photo-1549880181-59a44fc0afdc?auto=format&fit=crop&w=1000&q=80',
        caption: 'Beautiful morning at Mount Yemma Gouraya! The view is breathtaking ⛰️🇩🇿 #Bejaia #Nature',
        tags: ['#Bejaia', '#Nature'],
        likes: 124,
        comments: 18,
        isLiked: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        achievementBadge: '⛰️ Climber',
        distanceKm: 8.5,
        time: const Duration(hours: 3, minutes: 20),
        difficulty: 'Hard',
      ),
      PostModel(
        id: '2',
        userId: 'm2',
        username: 'Amira_Dz',
        wilayaBadge: 'Algiers',
        journeyId: 'j2',
        photoUrl: 'https://images.unsplash.com/photo-1523211711685-610118679093?auto=format&fit=crop&w=1000&q=80',
        caption: 'Walking through Casbah historic streets. History in every corner ✨ #Casbah',
        tags: ['#History'],
        likes: 342,
        comments: 54,
        isLiked: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        achievementBadge: '🏺 Explorer',
        distanceKm: 4.2,
        time: const Duration(hours: 2, minutes: 15),
        difficulty: 'Medium',
      ),
      PostModel(
        id: '3',
        userId: 'm3',
        username: 'Khaled_Sahara',
        wilayaBadge: 'Tamanrasset',
        journeyId: 'j3',
        photoUrl: 'https://images.unsplash.com/photo-1509114397022-ed747cca3f65?auto=format&fit=crop&w=1000&q=80',
        caption: 'Assekrem... The sunset here is unlike anywhere else. A true challenge 🐪🔥',
        tags: ['#Sahara'],
        likes: 890,
        comments: 120,
        isLiked: false,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        achievementBadge: '🐪 Nomad',
        distanceKm: 12.0,
        time: const Duration(hours: 6, minutes: 0),
        difficulty: 'Extreme',
      ),
    ];
    
    _posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _isLoading = false;
    Future.microtask(() => notifyListeners());
  }

  Future<void> addPost(PostModel post) async {
    _posts.insert(0, post);
    await _savePosts();
    notifyListeners();
  }

  void toggleLike(String postId) async {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx != -1) {
      if (_posts[idx].isLiked) {
        _posts[idx].isLiked = false;
        _posts[idx].likes -= 1;
      } else {
        _posts[idx].isLiked = true;
        _posts[idx].likes += 1;
      }
      await _savePosts();
      notifyListeners();
    }
  }

  Future<void> _savePosts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('social_posts', jsonEncode(_posts.map((p) => p.toJson()).toList()));
  }
}
