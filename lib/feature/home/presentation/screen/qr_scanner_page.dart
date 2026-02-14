import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../bloc/home_bloc.dart';

@RoutePage()
class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage>
    with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
    autoStart: true,
  );

  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        if (controller.value.isInitialized) {
          controller.start();
        }
        break;
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is inactive.
        if (controller.value.isInitialized) {
          controller.stop();
        }
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      final String? rawValue = barcode.rawValue;
      if (rawValue != null && rawValue.isNotEmpty) {
        setState(() {
          _isScanning = false;
        });

        // Trigger search in HomeBloc
        context.read<HomeBloc>().add(QRCodeScannedEvent(rawValue));

        // Pop back to home screen
        context.router.back();
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Book QR/Barcode'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, state, child) {
                if (!state.isInitialized || !state.isRunning) {
                  return const SizedBox();
                }

                switch (state.torchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                  case TorchState.auto:
                    return const Icon(Icons.flash_auto, color: Colors.blue);
                  default:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                }
              },
            ),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, state, child) {
                if (!state.isInitialized || !state.isRunning) {
                  return const SizedBox();
                }

                switch (state.cameraDirection) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _onDetect,
            overlayBuilder: (context, constraints) {
              return Container(
                decoration: ShapeDecoration(
                  shape: QrScannerOverlayShape(
                    borderColor: Theme.of(context).primaryColor,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300,
                  ),
                ),
              );
            },
          ),
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              'Align QR code or Barcode within the frame',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the overlay manually if needed,
// but mobile_scanner doesn't always provide a built-in shape class in newer versions
// like qr_code_scanner did.
// Let's create a simple overlay painter to mimic the scanner look.

class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 10.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final _cutOutSize = cutOutSize;
    final _borderLength = borderLength;
    final _borderRadius = borderRadius;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill;

    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - _cutOutSize / 2 + borderOffset,
      rect.top + height / 2 - _cutOutSize / 2 + borderOffset,
      _cutOutSize - borderOffset * 2,
      _cutOutSize - borderOffset * 2,
    );

    canvas
      ..saveLayer(rect, backgroundPaint)
      ..drawRect(rect, backgroundPaint)
      ..drawRRect(
        RRect.fromRectAndRadius(cutOutRect, Radius.circular(_borderRadius)),
        Paint()..blendMode = BlendMode.clear,
      )
      ..restore();

    final cutOutBottom = cutOutRect.bottom;
    final cutOutTop = cutOutRect.top;
    final cutOutLeft = cutOutRect.left;
    final cutOutRight = cutOutRect.right;

    final path = Path();

    path.moveTo(cutOutLeft, cutOutTop + _borderLength);
    path.lineTo(cutOutLeft, cutOutTop + _borderRadius);
    path.quadraticBezierTo(
      cutOutLeft,
      cutOutTop,
      cutOutLeft + _borderRadius,
      cutOutTop,
    );
    path.lineTo(cutOutLeft + _borderLength, cutOutTop);

    path.moveTo(cutOutRight, cutOutTop + _borderLength);
    path.lineTo(cutOutRight, cutOutTop + _borderRadius);
    path.quadraticBezierTo(
      cutOutRight,
      cutOutTop,
      cutOutRight - _borderRadius,
      cutOutTop,
    );
    path.lineTo(cutOutRight - _borderLength, cutOutTop);

    path.moveTo(cutOutRight, cutOutBottom - _borderLength);
    path.lineTo(cutOutRight, cutOutBottom - _borderRadius);
    path.quadraticBezierTo(
      cutOutRight,
      cutOutBottom,
      cutOutRight - _borderRadius,
      cutOutBottom,
    );
    path.lineTo(cutOutRight - _borderLength, cutOutBottom);

    path.moveTo(cutOutLeft, cutOutBottom - _borderLength);
    path.lineTo(cutOutLeft, cutOutBottom - _borderRadius);
    path.quadraticBezierTo(
      cutOutLeft,
      cutOutBottom,
      cutOutLeft + _borderRadius,
      cutOutBottom,
    );
    path.lineTo(cutOutLeft + _borderLength, cutOutBottom);

    canvas.drawPath(path, borderPaint);
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
      borderRadius: borderRadius,
      borderLength: borderLength,
      cutOutSize: cutOutSize,
    );
  }
}
