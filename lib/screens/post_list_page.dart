import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'post_detail_page.dart';
import 'post_form_page.dart';
import '../widgets/post_grid_card.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF31694E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF31694E),
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Daftar Postingan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color(0xFFF87B1B),
          ),
        ),
      ),
      body: FutureBuilder<List<Post>>(
        future: api.fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada postingan.'));
          } else {
            final posts = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 200,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostGridCard(
                    post: post,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailPage(id: post.id),
                        ),
                      );
                      setState(() {});
                    },
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6C63FF),
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PostFormPage()),
          );
          setState(() {});
        },
      ),
    );
  }
}
