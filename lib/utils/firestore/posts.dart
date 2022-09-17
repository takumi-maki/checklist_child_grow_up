import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/model/post.dart';
import 'package:flutter/material.dart';

class PostFirestore {
  static final _firebaseFirestore = FirebaseFirestore.instance;
  // 全体のpostsドキュメント
  static final CollectionReference posts = _firebaseFirestore.collection('posts');

  static Future<bool> addPost(Post newPost) async {
    try {
      // 自分専用のpostsドキュメント
      final CollectionReference userPosts = _firebaseFirestore.collection('users')
          .doc(newPost.postAccountId).collection('my_posts');
      var result = await posts.add({
        'content': newPost.content,
        'post_account_id': newPost.postAccountId,
        'created_time': Timestamp.now(),
      });
      await userPosts.doc(result.id).set({
        'post_id': result.id,
        'created_time': Timestamp.now(),
      });
      debugPrint('投稿完了');
      return true;
    } on FirebaseException catch(e) {
      debugPrint('投稿エラー :$e');
      return false;
    }
  }

  static Future<List<Post>?> getPostsFromIds(List<String> ids) async {
    List<Post> postList = [];
    try {
      await Future.forEach(ids, (String id) async {
        var doc = await posts.doc(id).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Post post = Post(
          id: doc.id,
          content: data['content'],
          postAccountId: data['post_account_id'],
          createdTime: data['created_time'],
        );
        postList.add(post);
      });
      debugPrint('自分の投稿取得完了');
      return postList;
    } on FirebaseException catch(e) {
      debugPrint('自分の投稿取得エラー: $e');
      return null;
    }
  }
  static Future<dynamic> deletePosts(String accountId) async {
    final CollectionReference userPosts = _firebaseFirestore.collection('users')
        .doc(accountId).collection('my_posts');
    var snapShot = await userPosts.get();
    for (var doc in snapShot.docs) {
      await posts.doc(doc.id).delete();
      await userPosts.doc(doc.id).delete();
    }
  }
}