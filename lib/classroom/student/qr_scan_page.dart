import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:spaghetti/classroom/instructor/classroomService.dart';
import 'package:spaghetti/classroom/classDetailPage.dart';
import 'package:spaghetti/Dialog/CicularProgress.dart';
import 'package:spaghetti/classroom/student/EnrollmentService.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isLoading = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid || Platform.isIOS) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      if (!isLoading && scanData.code != null) {
        setState(() {
          result = scanData;
          isLoading = true;
        });

        String pin = scanData.code!;
        await controller.pauseCamera(); // QR 코드 스캔 중지

        var classroomService =
            Provider.of<ClassroomService>(context, listen: false);
        var classroom =
            await classroomService.studentEnterClassPin(context, pin);

        setState(() {
          isLoading = false;
        });

        if (classroom != null) {
          await Provider.of<EnrollmentService>(context, listen: false)
              .addEnrollList(context, classroom);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => classDetailPage(
                classroom: classroom,
              ),
            ),
          );
        } else {
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR 코드 스캔'),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: (result != null)
                      ? Text('QR 코드 데이터: ${result!.code}')
                      : Text('QR 코드를 스캔해주세요.'),
                ),
              ),
            ],
          ),
          if (isLoading) CircularProgress.build(),
        ],
      ),
    );
  }
}
