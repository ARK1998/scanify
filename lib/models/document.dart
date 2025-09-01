// models/document.dart
class Document {
  final String id;
  final String title;
  final DateTime createdDate;
  final String imagePath;
  final String? pdfPath;
  final int pageCount;

  Document({
    required this.id,
    required this.title,
    required this.createdDate,
    required this.imagePath,
    this.pdfPath,
    this.pageCount = 1,
  });

  // Convert to/from JSON for storage
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdDate': createdDate.toIso8601String(),
        'imagePath': imagePath,
        'pdfPath': pdfPath,
        'pageCount': pageCount,
      };

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json['id'],
        title: json['title'],
        createdDate: DateTime.parse(json['createdDate']),
        imagePath: json['imagePath'],
        pdfPath: json['pdfPath'],
        pageCount: json['pageCount'],
      );
}