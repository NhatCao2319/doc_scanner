import 'package:document_scanner_app/Models/doc_page.dart';

const String tableDocuments = 'document';

class DocumentFields {
  static final List<String> values = [id, name, createAt, docPath];

  static const String id = '_id';
  static const String name = 'name';
  static const String createAt = 'createAt';
  static const String docPath = 'docPath';
}

class Document {
  final int? id;
  final String? name;
  final DateTime? createAt;
  final String? docPath;
  final List<DocPage> pages;

  const Document({
    this.id,
    this.name,
    this.createAt,
    this.docPath,
    this.pages = const [],
  });

  Document copy({
    int? id,
    final String? name,
    final DateTime? createAt,
    final String? docPath,
    final List<DocPage>? pages,
  }) =>
      Document(
        id: id ?? this.id,
        name: name ?? this.name,
        createAt: createAt ?? this.createAt,
        docPath: docPath ?? this.docPath,
        pages: pages ?? this.pages,
      );

  static Document fromJson(Map<String, Object?> json) => Document(
        id: json[DocumentFields.id] as int?,
        name: json[DocumentFields.name] as String?,
        createAt: DateTime.parse(json[DocumentFields.createAt] as String),
        docPath: json[DocumentFields.docPath] as String?,
      );

  Map<String, Object?> toJson() => {
        DocumentFields.id: id,
        DocumentFields.name: name,
        DocumentFields.createAt: createAt!.toIso8601String(),
        DocumentFields.docPath: docPath,
      };
}
