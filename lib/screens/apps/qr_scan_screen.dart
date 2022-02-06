import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_connector/wifi_connector.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({Key? key}) : super(key: key);

  @override
  _QrScanScreenState createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String finalWifiName = '';

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
                        '${result!.code}',
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

  checkingUrlAndLaunch() async {
    if (result!.code != null || result!.code != '') {
      if (result!.code!.contains('https') || result!.code!.contains('http')) {
        return launchURL(result!.code!);
      }
      if (result!.code!.contains('WIFI') || result!.code!.contains('wifi')) {
        showOptionsDialog(context);
        return;
      }
    }
  }

  launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  connectWifi(String data) async {
    String wifiName = '';
    String wifiPass = '';
    final wifiData = data.split(";");
    for (String data in wifiData) {
      if (data.contains('S:')) {
        wifiName = data.substring(data.indexOf('S:') + 2, data.length);
        setState(() {
          finalWifiName = wifiName;
        });
      }
      if (data.contains('P:')) {
        wifiPass = data.substring(data.indexOf('P:') + 2, data.length);
      }
    }
    if (!await WifiConnector.connectToWifi(
        ssid: wifiName, password: wifiPass)) {
      throw 'Could not connect to wifi';
    } else {
      return;
    }
  }

  Future<void> showOptionsDialog(BuildContext context) async {
    String wifiName = '';
    final wifiData = result!.code!.split(";");
    for (String data in wifiData) {
      if (data.contains('S:')) {
        wifiName = data.substring(data.indexOf('S:') + 2, data.length);
        setState(() {
          finalWifiName = wifiName;
        });
      }
    }
    String textResult = 'Join Wi-Fi Network\n' '"$finalWifiName"';
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            buttonPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.h),
            titlePadding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
            backgroundColor: Colors.grey.shade400,
            title: Center(
                child: Text(
              textResult,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            )),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
            insetPadding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 16.sp, color: Colors.blue.shade400),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      connectWifi(result!.code!);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Join',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
