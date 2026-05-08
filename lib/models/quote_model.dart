class QuoteModel {
  const QuoteModel({required this.content, required this.author});

  final String content;
  final String author;

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      content:
          (json['q'] ?? json['content']) as String? ??
          'The secret of getting ahead is getting started.',
      author: (json['a'] ?? json['author']) as String? ?? 'Mark Twain',
    );
  }
}
