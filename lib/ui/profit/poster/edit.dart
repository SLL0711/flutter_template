import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/profit/poster/create.dart';
import 'package:flutter_medical_beauty/ui/profit/poster/widgets.dart';

import '../../../colors.dart';

class PosterEditScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PosterEditScreenState();
}

class PosterEditScreenState extends State<PosterEditScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(context, '编辑海报', () {
          Navigator.pop(context);
        }),
        body: Column(children: [
          Expanded(child: PosterWidgets.editPosterWidget(context)),
          Container(
            padding: const EdgeInsets.only(top: 4, left: 27, right: 25),
            height: 104,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PosterWidgets.editPosterButton(context, '更换图片', () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PosterCreateScreen()));
                }),
                PosterWidgets.editPosterButton(context, '上传图片', () {

                }),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 50,
            color: XCColors.bannerSelectedColor,
            child: Text('生成海报',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          )
        ]));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}