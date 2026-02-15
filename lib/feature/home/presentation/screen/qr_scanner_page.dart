import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:books_discovery_app/feature/auth/presentation/bloc/auth_bloc.dart';
import '../bloc/home_bloc.dart';
import '../widgets/qr_scanner_overlay_shape.dart';

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
        final authBloc = context.read<AuthBloc>();
        final userId = authBloc.state is Authenticated
            ? (authBloc.state as Authenticated).user.id
            : '';

        context.read<HomeBloc>().add(QRCodeScannedEvent(rawValue, userId));

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
                    return const Icon(Icons.camera_alt);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_alt);
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
