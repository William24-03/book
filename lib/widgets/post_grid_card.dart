import 'package:flutter/material.dart';
import '../models/post.dart';

class PostGridCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;

  const PostGridCard({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Placeholder gambar (diganti jadi ikon artikel)
              Container(
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF31694E).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.article_outlined, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                post.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "oleh ${post.author}",
                style: const TextStyle(color: Color(0xFFF87B1B), fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
