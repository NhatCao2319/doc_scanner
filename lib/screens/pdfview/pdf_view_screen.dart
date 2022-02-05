import 'package:document_scanner_app/Models/document.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class PdfViewScreen extends StatefulWidget {
  final Document document;
  const PdfViewScreen({Key? key, required this.document}) : super(key: key);

  @override
  _PdfViewScreenState createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  static const int _initialPage = 1;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;
  bool isSampleDoc = true;
  late PdfController _pdfController;

  @override
  void initState() {
    _pdfController = PdfController(
      document: PdfDocument.openFile(widget.document.docPath!),
      initialPage: _initialPage,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(primaryColor: Colors.white),
        home: Scaffold(
          appBar: AppBar(
            elevation: 0.4,
            backgroundColor: Colors.pink.shade200,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.chevron_left_rounded,
                size: 30,
                color: Colors.black54,
              ),
            ),
            title: Text(
              widget.document.name!,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            actions: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Text(
                  '$_actualPageNumber/$_allPagesCount',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  size: 30,
                  color: Colors.black54,
                ),
                onPressed: () {
                  if (isSampleDoc) {
                    _pdfController.loadDocument(
                        PdfDocument.openFile(widget.document.docPath!));
                  } else {
                    _pdfController.loadDocument(
                        PdfDocument.openFile(widget.document.docPath!));
                  }
                  isSampleDoc = !isSampleDoc;
                },
              )
            ],
          ),
          body: PdfView(
            documentLoader: const Center(child: CircularProgressIndicator()),
            pageLoader: const Center(child: CircularProgressIndicator()),
            controller: _pdfController,
            scrollDirection: Axis.vertical,
            onDocumentLoaded: (document) {
              setState(() {
                _allPagesCount = document.pagesCount;
              });
            },
            onPageChanged: (page) {
              setState(() {
                _actualPageNumber = page;
              });
            },
            onDocumentError: (error) => {},
          ),
        ),
      );
}
