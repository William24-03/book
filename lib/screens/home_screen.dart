import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/book.dart';
import 'book_detail_screen.dart';
import 'create_edit_book_screen.dart';
import '../widgets/book_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Book>> _books;

  @override
  void initState() {
    super.initState();
    _books = ApiService.fetchBooks();
  }

  void refreshData() {
    setState(() {
      _books = ApiService.fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book List"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 1,
      ),
      body: FutureBuilder<List<Book>>(
        future: _books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No books found",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          final books = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              return BookCard(
                book: books[index],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookDetailScreen(
                      id: books[index].id,
                      onRefresh: refreshData,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add),
        label: const Text("Add Book"),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CreateEditBookScreen(onRefresh: refreshData),
          ),
        ),
      ),
    );
  }
}
