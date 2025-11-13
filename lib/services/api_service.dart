import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  final String baseUrl = 'https://hmti-news.hppms-sabala.my.id/api';

  // GET semua post
  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((p) => Post.fromJson(p)).toList();
    } else {
      throw Exception('Gagal memuat data post');
    }
  }

  // GET post berdasarkan ID
  Future<Post> fetchPostById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/$id'));
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Post tidak ditemukan');
    }
  }

  // POST tambah post
  Future<void> addPost(Post post) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/posts'));
    request.fields.addAll(post.toMap());
    var response = await request.send();
    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan post');
    }
  }

  //  PUT update post (pakai _method=PUT agar diterima Laravel)
  Future<void> updatePost(int id, Post post) async {
    var uri = Uri.parse('$baseUrl/posts/$id');
    var request = http.MultipartRequest('POST', uri);
    request.fields.addAll({
      '_method': 'PUT', // penting agar Laravel paham ini update
      ...post.toMap(),
    });

    var response = await request.send();

    if (response.statusCode != 200 && response.statusCode != 201) {
      final resBody = await response.stream.bytesToString();
      throw Exception(
          'Gagal memperbarui post: ${response.statusCode} → $resBody');
    }
  }

  // DELETE hapus post
  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus post');
    }
  }
}
