import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({Key? key}) : super(key: key);

  @override
  _QrScanScreenState createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderLength: 20,
              borderWidth: 8,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
              borderRadius: 12,
            ),
          ),
          Positioned(
            bottom: 60,
            child: result != null
                ? GestureDetector(
                    onTap: () {
                      checkingUrlAndLaunch();
                    },
                    child: Container(
                      width: 300.w,
                      child: Text(
                        'Result: ${result!.code}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w500),
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: Colors.white24,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: GFIconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                size: GFSize.MEDIUM,
                icon:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  checkingUrlAndLaunch() {
    if (result!.code != null || result!.code != '') {
      if (result!.code!.contains('https') || result!.code!.contains('http')) {
        return launchURL(result!.code!);
      }
    }
  }

  launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}
