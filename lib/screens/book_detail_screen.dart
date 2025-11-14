import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import 'create_edit_book_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final int id;
  final Function onRefresh;

  const BookDetailScreen({
    super.key,
    required this.id,
    required this.onRefresh,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late Future<Book> _book;

  @override
  void initState() {
    super.initState();
    _book = ApiService.fetchBookById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Detail"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<Book>(
        future: _book,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snap.hasData) {
            return const Center(child: Text("Data not found"));
          }

          final book = snap.data!;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  "by ${book.author}",
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    book.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateEditBookScreen(
                              onRefresh: widget.onRefresh,
                              book: book,
                            ),
                          ),
                        );
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        final success = await ApiService.deleteBook(book.id);
                        if (success) {
                          widget.onRefresh();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
