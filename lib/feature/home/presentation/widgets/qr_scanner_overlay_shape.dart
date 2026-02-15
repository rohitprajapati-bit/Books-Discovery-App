import 'package:flutter/material.dart';

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
    final cutOutSizeVal = cutOutSize;
    final borderLengthVal = borderLength;
    final borderRadiusVal = borderRadius;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - cutOutSizeVal / 2 + borderOffset,
      rect.top + height / 2 - cutOutSizeVal / 2 + borderOffset,
      cutOutSizeVal - borderOffset * 2,
      cutOutSizeVal - borderOffset * 2,
    );

    canvas
      ..saveLayer(rect, backgroundPaint)
      ..drawRect(rect, backgroundPaint)
      ..drawRRect(
        RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadiusVal)),
        Paint()..blendMode = BlendMode.clear,
      )
      ..restore();

    final cutOutBottom = cutOutRect.bottom;
    final cutOutTop = cutOutRect.top;
    final cutOutLeft = cutOutRect.left;
    final cutOutRight = cutOutRect.right;

    final path = Path();

    path.moveTo(cutOutLeft, cutOutTop + borderLengthVal);
    path.lineTo(cutOutLeft, cutOutTop + borderRadiusVal);
    path.quadraticBezierTo(
      cutOutLeft,
      cutOutTop,
      cutOutLeft + borderRadiusVal,
      cutOutTop,
    );
    path.lineTo(cutOutLeft + borderLengthVal, cutOutTop);

    path.moveTo(cutOutRight, cutOutTop + borderLengthVal);
    path.lineTo(cutOutRight, cutOutTop + borderRadiusVal);
    path.quadraticBezierTo(
      cutOutRight,
      cutOutTop,
      cutOutRight - borderRadiusVal,
      cutOutTop,
    );
    path.lineTo(cutOutRight - borderLengthVal, cutOutTop);

    path.moveTo(cutOutRight, cutOutBottom - borderLengthVal);
    path.lineTo(cutOutRight, cutOutBottom - borderRadiusVal);
    path.quadraticBezierTo(
      cutOutRight,
      cutOutBottom,
      cutOutRight - borderRadiusVal,
      cutOutBottom,
    );
    path.lineTo(cutOutRight - borderLengthVal, cutOutBottom);

    path.moveTo(cutOutLeft, cutOutBottom - borderLengthVal);
    path.lineTo(cutOutLeft, cutOutBottom - borderRadiusVal);
    path.quadraticBezierTo(
      cutOutLeft,
      cutOutBottom,
      cutOutLeft + borderRadiusVal,
      cutOutBottom,
    );
    path.lineTo(cutOutLeft + borderLengthVal, cutOutBottom);

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
