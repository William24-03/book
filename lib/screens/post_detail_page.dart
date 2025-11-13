import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'edit_post_page.dart';

class PostDetailPage extends StatefulWidget {
  final int id;
  const PostDetailPage({super.key, required this.id});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF31694E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF31694E),
        title:
            const Text('Detail Post', style: TextStyle(color: Colors.black87)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: FutureBuilder<Post>(
        future: api.fetchPostById(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Post tidak ditemukan.'));
          } else {
            final post = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("Oleh: ${post.author}",
                      style: const TextStyle(color: Colors.black54)),
                  const Divider(height: 20, thickness: 1),
                  Text(post.content),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditPostPage(post: post),
                            ),
                          );
                          setState(() {});
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF31694E),
                          foregroundColor: const Color(0xFFF87B1B),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await api.deletePost(post.id);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Hapus'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF87B1B),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
