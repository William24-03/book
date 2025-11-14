// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static const String baseUrl = 'https://hppms-sabala.my.id/api';

  // replace with your token (or load from secure storage later)
  static const String token =
      '913|d0PJQI8izPiwDtnn6gVbv3Uv3tRiTUxtcwzVCOBL2b2e148d';

  static Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  // ---------------------------
  // Helper parsers (robust)
  // ---------------------------
  static List<dynamic> _parseListPayload(dynamic decoded) {
    // Cases handled:
    // 1) response is a raw List -> decoded is List
    // 2) response is Map and decoded['data'] is List
    // 3) response is Map and decoded['data']['data'] is List (nested)
    if (decoded == null) return <dynamic>[];
    if (decoded is List) return decoded;
    if (decoded is Map<String, dynamic>) {
      if (decoded['data'] is List) return decoded['data'] as List<dynamic>;
      if (decoded['data'] is Map && decoded['data']['data'] is List) {
        return decoded['data']['data'] as List<dynamic>;
      }
      // sometimes API returns { "success": true, "data": { "books": [...] } }
      if (decoded['data'] is Map && decoded['data']['books'] is List) {
        return decoded['data']['books'] as List<dynamic>;
      }
    }
    return <dynamic>[];
  }

  static Map<String, dynamic>? _parseObjectPayload(dynamic decoded) {
    // Return the object Map that actually contains book fields.
    if (decoded == null) return null;
    if (decoded is Map<String, dynamic>) {
      if (decoded['data'] is Map<String, dynamic>) {
        return decoded['data'] as Map<String, dynamic>;
      }
      // sometimes API returns the object directly
      // or nested under 'book' or similar
      if (_looksLikeBook(decoded)) return decoded;
      if (decoded['book'] is Map<String, dynamic>) {
        return decoded['book'] as Map<String, dynamic>;
      }
    }
    return null;
  }

  static bool _looksLikeBook(Map<String, dynamic> map) {
    // crude heuristic: presence of 'id' or 'title' keys
    return map.containsKey('id') || map.containsKey('title');
  }

  // ---------------------------
  // GET ALL BOOKS
  // ---------------------------
  static Future<List<Book>> fetchBooks() async {
    final uri = Uri.parse('$baseUrl/books');
    final response = await http.get(uri, headers: _headers);

    // debug print (remove or lower verbosity in production)
    // ignore: avoid_print
    print('[ApiService.fetchBooks] ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      final decoded = _safeJsonDecode(response.body);
      final list = _parseListPayload(decoded);
      return list
          .whereType<dynamic>()
          .map((e) => Book.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    throw Exception(
        'Failed to load books (code ${response.statusCode}): ${response.body}');
  }

  // ---------------------------
  // GET BOOK BY ID
  // ---------------------------
  static Future<Book> fetchBookById(int id) async {
    final uri = Uri.parse('$baseUrl/books/$id');
    final response = await http.get(uri, headers: _headers);

    // debug print
    // ignore: avoid_print
    print('[ApiService.fetchBookById] ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      final decoded = _safeJsonDecode(response.body);
      final obj = _parseObjectPayload(decoded);
      if (obj != null) {
        return Book.fromJson(obj);
      } else {
        throw Exception('Unexpected book detail format: ${response.body}');
      }
    }

    throw Exception(
        'Failed to load book detail (code ${response.statusCode}): ${response.body}');
  }

  // ---------------------------
  // CREATE BOOK
  // ---------------------------
  static Future<bool> createBook(Book book) async {
    final uri = Uri.parse('$baseUrl/books');
    final response = await http.post(uri,
        headers: _headers, body: jsonEncode(book.toJson()));

    // debug print
    // ignore: avoid_print
    print('[ApiService.createBook] ${response.statusCode} ${response.body}');

    // success usually 201, some APIs return 200
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    }

    // optionally you can throw here to show detailed error
    // throw Exception('Create failed: ${response.statusCode} ${response.body}');
    return false;
  }

  // ---------------------------
  // UPDATE BOOK
  // ---------------------------
  static Future<bool> updateBook(int id, Book book) async {
    final uri = Uri.parse('$baseUrl/books/$id');
    final response =
        await http.put(uri, headers: _headers, body: jsonEncode(book.toJson()));

    // debug print
    // ignore: avoid_print
    print('[ApiService.updateBook] ${response.statusCode} ${response.body}');

    return response.statusCode == 200;
  }

  // ---------------------------
  // DELETE BOOK
  // ---------------------------
  static Future<bool> deleteBook(int id) async {
    final uri = Uri.parse('$baseUrl/books/$id');
    final response = await http.delete(uri, headers: _headers);

    // debug print
    // ignore: avoid_print
    print('[ApiService.deleteBook] ${response.statusCode} ${response.body}');

    return response.statusCode == 200 || response.statusCode == 204;
  }

  // ---------------------------
  // safe json decode helper
  // ---------------------------
  static dynamic _safeJsonDecode(String source) {
    if (source.trim().isEmpty) return null;
    try {
      return json.decode(source);
    } catch (e) {
      // ignore: avoid_print
      print('[ApiService._safeJsonDecode] decode error: $e');
      return null;
    }
  }
}
