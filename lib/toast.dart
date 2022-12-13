import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';

class ToastHud {
  static OverlayEntry? _overlayEntry;

  static loading(BuildContext context) async {
    dismiss();
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return _buildLoading();
    });
    _overlayEntry = overlayEntry;
    overlayState!.insert(overlayEntry);
  }

  static dismiss() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  static show(BuildContext context, String msg) async {
    dismiss();
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return _buildMsg(context, msg);
    });
    _overlayEntry = overlayEntry;
    overlayState!.insert(overlayEntry);
    await Future.delayed(const Duration(seconds: 2));
    dismiss();
  }

  static Widget _buildMsg(BuildContext context, String msg) {
    return Material(
        color: Colors.transparent,
        child: Center(
            child: Container(
                decoration: BoxDecoration(
                    color: XCColors.bannerSelectedColor,
                    borderRadius: BorderRadius.circular(5.0)),
                padding: EdgeInsets.all(10.0),
                child: Text(msg,
                    style: TextStyle(color: Colors.white, fontSize: 16)))));
  }

  static Widget _buildLoading() {
    return Material(
        color: Colors.transparent,
        child: Center(
            child: CircularProgressIndicator(
                color: XCColors.bannerSelectedColor)));
  }
}
