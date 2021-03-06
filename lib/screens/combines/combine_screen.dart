import 'dart:io';
import 'package:document_scanner_app/Models/doc_page.dart';
import 'package:document_scanner_app/Models/document.dart';
import 'package:document_scanner_app/Providers/document_provider.dart';
import 'package:document_scanner_app/const/app_corlors.dart';
import 'package:document_scanner_app/db/document_database.dart';
import 'package:document_scanner_app/screens/edits/edit_screen.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class CombineScreen extends StatefulWidget {
  final Document document;
  const CombineScreen({Key? key, required this.document}) : super(key: key);

  @override
  _CombineScreenState createState() => _CombineScreenState();
}

class _CombineScreenState extends State<CombineScreen> {
  final TextEditingController _textFieldController = TextEditingController();
  int counter = 0;
  List<DocPage> list = [];
  final pdf = pw.Document();
  final List<File> _image = [];
  String? currentDocName;
  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  void refreshData() {
    final pages = DocumentDataBase.instance
        .readAllPagesById(widget.document.id.toString());
    pages.then((value) {
      setState(() {
        if (list.isNotEmpty) {
          list.clear();
        }
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
              return GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => EditScreen(
                                document: widget.document,
                                docPage: list[index],
                                imgPath: list[index].pagePath!,
                              )));
                },
                onLongPress: () {
                  showDeleteDialog(context, index);
                },
                child: Card(
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
                ),
              );
            }),
      ),
      floatingActionButton: SizedBox(
        child: GFIconButton(
          buttonBoxShadow: true,
          shape: GFIconButtonShape.circle,
          onPressed: () async {
            String? imagePath = await EdgeDetection.detectEdge;
            if (imagePath != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditScreen(
                          document: widget.document, imgPath: imagePath)));
            }
          },
          icon: const Icon(Icons.add_a_photo_rounded, color: Colors.white),
          color: Colors.pink.shade200,
          borderShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0.r)),
        ),
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      title: GestureDetector(
        onTap: () => _displayRenameDialog(context),
        child: Text(
          currentDocName ?? widget.document.name!,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
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
      automaticallyImplyLeading: false,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: GFButton(
            onPressed: () async {
              if (counter <= 0) {
                setState(() {
                  counter++;
                });
                await createPDF();
                await savePDF();
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            text: "Create",
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

      await Provider.of<DocumentProvider>(context, listen: false)
          .updateDocPath(int.parse(widget.document.id.toString()), file.path);
    }
    if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
      file = File('${dir.path}/${widget.document.name}.pdf');
      await file.writeAsBytes(await pdf.save());

      await Provider.of<DocumentProvider>(context, listen: false)
          .updateDocPath(int.parse(widget.document.id.toString()), file.path);
    }
  }

  Future<void> showDeleteDialog(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            buttonPadding: EdgeInsets.symmetric(horizontal: 20.w),
            title: const Text('Remove Page'),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            content: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: const Text('Are you sure to remove this page ?'),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GFButton(
                    elevation: 3.0,
                    onPressed: () {
                      DocumentDataBase.instance.deletePage(list[index].id!);
                      refreshData();
                      Navigator.pop(context);
                    },
                    text: "Yes",
                    color: Colors.pink.shade300,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  GFButton(
                    elevation: 3.0,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: "No",
                    color: Colors.pink.shade200,
                  ),
                ],
              ),
            ],
          );
        });
  }

  Future<void> _displayRenameDialog(BuildContext context) async {
    String nameText = '';
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            buttonPadding: EdgeInsets.symmetric(horizontal: 20.w),
            title: const Text('Rename'),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            content: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextField(
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    if (value.replaceAll(' ', '') != "") {
                      nameText = value;
                    }
                  });
                },
                controller: _textFieldController,
                decoration: InputDecoration(
                  hintText: "Your new name",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink.shade200),
                  ),
                  suffixIcon: IconButton(
                    onPressed: _textFieldController.clear,
                    icon: Icon(
                      Icons.clear,
                      color: Colors.pink.shade300,
                    ),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              GFButton(
                onPressed: () {
                  setState(() {
                    if (nameText.replaceAll(' ', '') != "") {
                      currentDocName = nameText;
                    } else {
                      currentDocName = currentDocName;
                    }
                  });
                  Provider.of<DocumentProvider>(context, listen: false)
                      .renameDoc(
                    widget.document.id!,
                    currentDocName!,
                  );
                  Navigator.pop(context);
                },
                text: "Ok",
                color: Colors.pink.shade200,
                fullWidthButton: true,
              ),
            ],
          );
        });
  }
}
