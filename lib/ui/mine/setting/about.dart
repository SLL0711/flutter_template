import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:package_info/package_info.dart';

class AboutScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen>
    with AutomaticKeepAliveClientMixin {
  String _version = '1.0.0';

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _version = packageInfo.version;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CityWidgets.cityAppBar(context, '关于雀斑', () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Container(
                height: 70,
                width: 70,
                child: Image.asset(
                    'assets/images/home/logo.png',
                    fit: BoxFit.cover)),
            SizedBox(height: 17),
            Text(
              '上海雀斑',
              style: TextStyle(
                fontSize: 18,
                color: XCColors.mainTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Version  $_version',
              style: TextStyle(
                fontSize: 14,
                color: XCColors.mainTextColor,
              ),
            ),
            SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                '     雀斑是专业医学美容社交电商平台，隶属于上海银可科技有限公司。    ',
                style: TextStyle(
                  fontSize: 14,
                  color: XCColors.mainTextColor,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                '       平台严选正规医疗商家并汇聚众多权威专家，致力于为雀斑会员提供正规的商家信息、放心的到店体验、超值的福利分享，支持无忧开店、精准广告推广以及专业IP打造，还能让你尽情分享快乐体验。雀斑让你光润玉颜，芳泽无加，守护你的青春容颜。',
                style: TextStyle(
                  fontSize: 14,
                  color: XCColors.mainTextColor,
                ),
              ),
            ),
            SizedBox(height: 34),
            Text(
              '上海银可科技有限公司 版本所有',
              style: TextStyle(
                fontSize: 10,
                color: XCColors.goodsOtherGrayColor,
              ),
            ),
            SizedBox(height: 5),
            Text(
              '沪ICP备2021037648号-1',
              style: TextStyle(
                fontSize: 10,
                color: XCColors.goodsOtherGrayColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
