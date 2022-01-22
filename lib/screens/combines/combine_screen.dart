import 'dart:io';
import 'package:document_scanner_app/Models/doc_page.dart';
import 'package:document_scanner_app/Models/document.dart';
import 'package:document_scanner_app/const/app_corlors.dart';
import 'package:document_scanner_app/db/document_database.dart';
import 'package:document_scanner_app/screens/edits/edit_screen.dart';
import 'package:document_scanner_app/screens/homes/home_screen.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../main_screen.dart';

class CombineScreen extends StatefulWidget {
  final Document document;
  const CombineScreen({Key? key, required this.document}) : super(key: key);

  @override
  _CombineScreenState createState() => _CombineScreenState();
}

class _CombineScreenState extends State<CombineScreen> {
  List<DocPage> list = [];
  final pdf = pw.Document();
  List<File> _image = [];
  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    final pages = DocumentDataBase.instance
        .readAllPagesById(widget.document.id.toString());
    pages.then((value) {
      setState(() {
        list.addAll(value);
      });
    });
    for (DocPage dp in list) {
      _image.add(File(dp.pagePath!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: buildAppbar(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: list.length,
            itemBuilder: (BuildContext ctx, index) {
              return Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: Image.file(
                    File(list[index].pagePath!),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 80.w,
            child: GFButton(
              onPressed: () async {
                String? imagePath = await EdgeDetection.detectEdge;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditScreen(
                            document: widget.document, imgPath: imagePath!)));
              },
              text: "Add image",
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
              color: Colors.pink.shade200,
              borderShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0.r)),
            ),
          ),
          SizedBox(
            width: 80.w,
            child: GFButton(
              onPressed: () async {},
              text: "Combine",
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
              color: Colors.pink.shade200,
              borderShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0.r)),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      title: Text(
        widget.document.name!,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.chevron_left_rounded,
          size: 30,
          color: Colors.black54,
        ),
      ),
      elevation: 0.4,
      backgroundColor: Colors.grey.shade200,
      automaticallyImplyLeading: true,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: GFButton(
            onPressed: () {
              createPDF();
              savePDF();
              var newRoute =
                  MaterialPageRoute(builder: (context) => const MainScreen());
              Navigator.pushReplacement(context, newRoute);
            },
            text: "Save",
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
            color: Colors.pink.shade200,
            borderShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0.r)),
          ),
        ),
      ],
    );
  }

  createPDF() async {
    refreshData();
    for (var img in _image) {
      final image = pw.MemoryImage(img.readAsBytesSync());

      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context contex) {
            return pw.Center(child: pw.Image(image));
          }));
    }
  }

  savePDF() async {
    Directory? dir;
    File? file;

    if (Platform.isAndroid) {
      dir = await getExternalStorageDirectory();
      file = File('${dir!.path}/${widget.document.name}.pdf');
      await file.writeAsBytes(await pdf.save());
      print(file.path);
    }
    if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
      file = File('${dir.path}/${widget.document.name}.pdf');
      await file.writeAsBytes(await pdf.save());
      print(file.path);
    }
  }
}
