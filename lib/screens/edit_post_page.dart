import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class EditPostPage extends StatefulWidget {
  final Post post;
  const EditPostPage({super.key, required this.post});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _authorController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _contentController = TextEditingController(text: widget.post.content);
    _authorController = TextEditingController(text: widget.post.author);
  }

  Future<void> _updatePost() async {
    if (_formKey.currentState!.validate()) {
      final updatedPost = Post(
        id: widget.post.id,
        title: _titleController.text,
        content: _contentController.text,
        author: _authorController.text,
      );

      try {
        await _apiService.updatePost(widget.post.id, updatedPost);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post berhasil diperbarui')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui post: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Post')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (v) => v!.isEmpty ? 'Judul wajib diisi' : null,
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Konten'),
                validator: (v) => v!.isEmpty ? 'Konten wajib diisi' : null,
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Penulis'),
                validator: (v) => v!.isEmpty ? 'Penulis wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updatePost,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF)),
                child: const Text('Perbarui'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
