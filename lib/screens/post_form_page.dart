import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class PostFormPage extends StatefulWidget {
  const PostFormPage({super.key});

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      final post = Post(
        id: 0,
        title: _titleController.text,
        content: _contentController.text,
        author: _authorController.text,
      );

      await _apiService.addPost(post);
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Post"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF)),
                child: const Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
