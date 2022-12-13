import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';

class AskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AskScreenState();
}

class AskScreenState extends State<AskScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CityWidgets.cityAppBar(context, '意见反馈', () {
          Navigator.pop(context);
        }),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 1, width: double.infinity, color: XCColors.homeDividerColor),
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(child: Text('请选择您的问题类型', style: TextStyle(fontSize: 16, color: XCColors.mainTextColor))),
                    SizedBox(width: 10),
                    Container(width: 7, height: 14, color: Colors.red)
                  ],
                ),
              ),
              Container(height: 1, width: double.infinity, color: XCColors.homeDividerColor),
              Container(
                height: 410,
                color: Colors.white,
                padding: const EdgeInsets.all(15),
                child: TextField(
                  style: TextStyle(fontSize: 16, color: XCColors.mainTextColor),
                  maxLines: 50,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '描述您的问题（字数请控制在300字以内哦）',
                    hintStyle: TextStyle(fontSize: 16, color: XCColors.tabNormalColor),
                    hintMaxLines: 2,
                  ),
                ),
              ),
              Container(height: 1, width: double.infinity, color: XCColors.homeDividerColor),
              Container(
                  alignment: Alignment.topLeft,
                  height: 50,
                  padding: const EdgeInsets.only(left: 15, top: 10),
                  child: Text('0/300', style: TextStyle(fontSize: 14, color: XCColors.tabNormalColor))),
              Container(
                  height: 80,
                  width: 80,
                  margin: const EdgeInsets.only(left: 15),
                  color: Colors.red),
              SizedBox(height: 50),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: XCColors.bannerSelectedColor,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Text(
                  '发布问题',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(height: 50)
            ],
          ),
        ));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
