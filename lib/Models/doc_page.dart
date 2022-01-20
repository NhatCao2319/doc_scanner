const String tablePages = 'pages';

class PageFields {
  static final List<String> values = [id, documentId, pagePath];
  static const String id = '_id';
  static const String documentId = 'documentId';
  static const String pagePath = 'path';
}

class DocPage {
  final int? id;
  final String? documentId;
  final String? pagePath;

  DocPage({
    this.id,
    required this.documentId,
    required this.pagePath,
  });

  DocPage copy({
    int? id,
    final String? documentId,
    final String? pagePath,
  }) =>
      DocPage(
        id: id ?? this.id,
        documentId: documentId ?? this.documentId,
        pagePath: pagePath ?? this.pagePath,
      );

  static DocPage fromJson(Map<String, Object?> json) => DocPage(
        id: json[PageFields.id] as int?,
        documentId: json[PageFields.documentId] as String?,
        pagePath: json[PageFields.pagePath] as String?,
      );

  Map<String, Object?> toJson() => {
        PageFields.id: id,
        PageFields.documentId: documentId,
        PageFields.pagePath: pagePath,
      };
}
