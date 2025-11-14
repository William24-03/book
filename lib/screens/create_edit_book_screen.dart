import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class CreateEditBookScreen extends StatefulWidget {
  final Function onRefresh;
  final Book? book;

  const CreateEditBookScreen({
    super.key,
    required this.onRefresh,
    this.book,
  });

  @override
  State<CreateEditBookScreen> createState() => _CreateEditBookScreenState();
}

class _CreateEditBookScreenState extends State<CreateEditBookScreen> {
  final titleC = TextEditingController();
  final authorC = TextEditingController();
  final descC = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      titleC.text = widget.book!.title;
      authorC.text = widget.book!.author;
      descC.text = widget.book!.description;
    }
  }

  Widget inputField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.book != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Book" : "Create Book"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            inputField("Title", titleC),
            inputField("Author", authorC),
            inputField("Description", descC, maxLines: 4),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text(
                  isEdit ? "Update" : "Create",
                  style: const TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () async {
                  final book = Book(
                    id: widget.book?.id ?? 0,
                    title: titleC.text,
                    author: authorC.text,
                    description: descC.text,
                  );

                  bool success;
                  if (isEdit) {
                    success =
                        await ApiService.updateBook(widget.book!.id, book);
                  } else {
                    success = await ApiService.createBook(book);
                  }

                  if (success) {
                    widget.onRefresh();
                    Navigator.pop(context);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
