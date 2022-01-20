import 'package:document_scanner_app/Models/document.dart';
import 'package:document_scanner_app/Models/doc_page.dart';
import 'package:document_scanner_app/db/document_database.dart';
import 'package:flutter/cupertino.dart';

class DocumentProvider with ChangeNotifier {
  final dbHelper = DocumentDataBase.instance;
  List<Document> _items = [];
  List<DocPage> _pageItems = [];

  List<Document> get docItems {
    return [..._items];
  }

  List<DocPage> get pageItems {
    return [..._pageItems];
  }

  Future<List<DocPage>> getPagesById(String docId) async {
    final pages = await dbHelper.readAllPagesById(docId);
    _pageItems = pages;
    notifyListeners();
    return pages;
  }

  Future<List<Document>> getDocs() async {
    final docs = await dbHelper.readAllDocuments();
    _items = docs;
    notifyListeners();
    return _items;
  }

  Future<Document> createDoc(String name, DateTime createAt) async {
    final doc = Document(
      id: DateTime.now().microsecondsSinceEpoch,
      name: name,
      createAt: createAt,
    );
    docItems.add(doc);
    await DocumentDataBase.instance.createDocument(doc);
    notifyListeners();
    return doc;
  }

  Future<DocPage> createPage(String docId, String path) async {
    final page = DocPage(documentId: docId, pagePath: path);
    pageItems.add(page);
    await DocumentDataBase.instance.createPage(page);
    notifyListeners();
    return page;
  }

  Future renameDoc(int id, String newName) async {
    final doc = _items.firstWhere((doc) => doc.id == id);
    final renameDoc = doc.copy(
        name: newName, createAt: doc.createAt, id: doc.id, pages: doc.pages);
    await dbHelper.updateDocument(renameDoc);
    notifyListeners();
  }

  Future deleteDoc(int id) async {
    _items.removeWhere((doc) => doc.id == id);
    notifyListeners();
    await dbHelper.deleteDocument(id);
  }

  Future deletePage(int id) async {
    _items.removeWhere((doc) => doc.id == id);
    notifyListeners();
    await dbHelper.deleteDocument(id);
  }
}
