import 'package:document_scanner_app/Models/document.dart';
import 'package:document_scanner_app/Models/doc_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DocumentDataBase {
  static final DocumentDataBase instance = DocumentDataBase._init();
  static Database? _database;
  DocumentDataBase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('documents.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _create);
  }

  Future _create(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute(''' 
CREATE TABLE $tableDocuments (
  ${DocumentFields.id} $idType,
  ${DocumentFields.name} $textType,
  ${DocumentFields.createAt} $textType
  )
    ''');

    await db.execute('''
CREATE TABLE $tablePages (
  ${PageFields.id} $idType,
  ${PageFields.documentId} $textType,
  ${PageFields.pagePath} $textType
  )
    ''');
  }

  // Add Doc
  Future<Document> createDocument(Document doc) async {
    final db = await instance.database;
    final id = await db.insert(tableDocuments, doc.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return doc.copy(id: id);
  }

  // Add Page
  Future<DocPage> createPage(DocPage page) async {
    final db = await instance.database;
    final id = await db.insert(tablePages, page.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return page.copy(id: id);
  }

  // Get Doc By ID
  Future<Document> readDocument(int id) async {
    final db = await instance.database;
    final result = await db.query(
      tableDocuments,
      columns: DocumentFields.values,
      where: '${DocumentFields.id} = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Document.fromJson(result.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // Get Page By ID
  Future<DocPage> readPage(int id) async {
    final db = await instance.database;
    final result = await db.query(
      tablePages,
      columns: PageFields.values,
      where: '${PageFields.id} = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return DocPage.fromJson(result.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // Get ALL Docs
  Future<List<Document>> readAllDocuments() async {
    final db = await instance.database;
    const orderBy = '${DocumentFields.createAt} ASC';
    final result = await db.query(tableDocuments, orderBy: orderBy);
    return result.map((json) => Document.fromJson(json)).toList();
  }

  Future _close() async {
    final db = await instance.database;
    db.close();
  }

  // Get ALL Pages By Id
  Future<List<DocPage>> readAllPagesById(String docId) async {
    final db = await instance.database;
    final result = await db.query(
      tablePages,
      where: '${PageFields.documentId} = ?',
      whereArgs: [docId],
    );
    return result.map((json) => DocPage.fromJson(json)).toList();
  }

  Future<List<DocPage>> readAllPages() async {
    final db = await instance.database;
    final result = await db.query(
      tablePages,
    );
    return result.map((json) => DocPage.fromJson(json)).toList();
  }

  // Update A Document
  Future<int> updateDocument(Document document) async {
    final db = await instance.database;
    return db.update(
      tableDocuments,
      document.toJson(),
      where: '${DocumentFields.id} = ?',
      whereArgs: [document.id],
    );
  }

  // Update A Page
  Future<int> updatePage(DocPage page) async {
    final db = await instance.database;
    return db.update(
      tablePages,
      page.toJson(),
      where: '${PageFields.id} = ?',
      whereArgs: [page.id],
    );
  }

  // Delete A Document
  Future<int> deleteDocument(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableDocuments,
      where: '${DocumentFields.id} = ?',
      whereArgs: [id],
    );
  }

  // Delete A Document
  Future<int> deletePage(int id) async {
    final db = await instance.database;
    return await db.delete(
      tablePages,
      where: '${PageFields.id} = ?',
      whereArgs: [id],
    );
  }
}
