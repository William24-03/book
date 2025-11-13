class Post {
  final int id;
  final String title;
  final String content;
  final String author;
  final String? image;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    this.image,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? '',
      image: json['image'],
    );
  }

  Map<String, String> toMap() {
    return {
      'title': title,
      'content': content,
      'author': author,
    };
  }
}
