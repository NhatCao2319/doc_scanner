import 'package:document_scanner_app/Providers/document_provider.dart';
import 'package:document_scanner_app/db/document_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class CustomSlidable extends StatelessWidget {
  final String docId;
  final Widget widget;
  const CustomSlidable({Key? key, required this.widget, required this.docId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),

      // The start action pane is the one at the left or the top side.

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        extentRatio: 0.38,
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              final doc = await DocumentDataBase.instance
                  .readDocument(int.parse(docId));
              Share.shareFiles([doc.docPath!], text: 'Share  PDF File');
            },
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Share',
          ),
          SlidableAction(
            onPressed: (_) async {
              await Provider.of<DocumentProvider>(context, listen: false)
                  .deleteDoc(int.parse(docId));
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: widget,
    );
  }
}
