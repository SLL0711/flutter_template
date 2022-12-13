import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medical_beauty/ui/profit/poster/widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../colors.dart';
import 'edit.dart';
import 'dart:ui' as ui;

class PosterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PosterScreenState();
}

class PosterScreenState extends State<PosterScreen>
    with AutomaticKeepAliveClientMixin {
  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: PosterWidgets.posterAppBar(context, '海报', () {
        Navigator.pop(context);
      }, () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PosterEditScreen()));
      }),
      body: Column(children: [
        Expanded(
          child: RepaintBoundary(
            key: globalKey,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(child: PosterWidgets.posterWidget(context)),
                  PosterWidgets.posterInfoWidget(context),
                ],
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 50,
          color: XCColors.bannerSelectedColor,
          child: GestureDetector(
            onTap: () async {
              saveImage(globalKey);
            },
            child: Text(
              '保存海报',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        )
      ]),
    );
  }

  /// 保存图片
  void saveImage(GlobalKey globalKey) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 6.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List picBytes = byteData!.buffer.asUint8List();

      bool isPermission = await _checkPermission();
      if (isPermission) {
        final result = await ImageGallerySaver.saveImage(picBytes,
            quality: 100, name: "share");
        print(result);
      } else {
        print('no permission');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) {
      var status = await Permission.photos.status;
      if (status.isGranted) {
        return true;
      } else {
        status = await Permission.photos.request();
        return status.isGranted;
      }
    } else if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status.isGranted) {
        return true;
      } else {
        status = await Permission.storage.request();
        return status.isGranted;
      }
    } else {
      return true;
    }
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
