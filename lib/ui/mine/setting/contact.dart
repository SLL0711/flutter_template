import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';

class ContactScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ContactScreenState();
}

class ContactScreenState extends State<ContactScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CityWidgets.cityAppBar(context, '联系我们', () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 51),
            Container(
              height: 70,
              width: 70,
              child: Image.asset(
                'assets/images/home/logo.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '雀斑APP',
              style: TextStyle(
                fontSize: 18,
                color: XCColors.mainTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text('守护我的青春容颜',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12, color: XCColors.tabNormalColor, height: 1.4)),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 19, right: 10),
              child: Text(
                '     无论您是对雀斑有宝贵意见，还是想与雀斑合作共赢;无论您是想成为雀斑达人，还是想加入雀斑团队，都欢迎通过以下方式联系我们，感谢您对雀斑的关注和关爱!',
                style: TextStyle(
                  fontSize: 14,
                  color: XCColors.mainTextColor,
                ),
              ),
            ),
            // SizedBox(height: 20),
            // Text('联系电话：400-602-5168',
            //     style:
            //         TextStyle(fontSize: 14, color: XCColors.mainTextColor)),
            SizedBox(height: 20),
            Text(
              '联系邮箱：contact@xiaoqingyan.com',
              style: TextStyle(
                fontSize: 14,
                color: XCColors.mainTextColor,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '雀斑官网：https://www.xiaoqingyan.com',
              style: TextStyle(
                fontSize: 14,
                color: XCColors.mainTextColor,
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
