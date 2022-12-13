import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';

import 'pay.dart';

class StoreReviewScreen extends StatefulWidget {
  final bool pass;

  StoreReviewScreen(this.pass);

  @override
  State<StatefulWidget> createState() => StoreReviewScreenState();
}

class StoreReviewScreenState extends State<StoreReviewScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _buildInReviewWidget() {
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(height: 1, color: XCColors.homeDividerColor),
            SizedBox(height: 56),
            Image.asset('assets/images/mine/mine_store_inreview.png',
                width: 198, height: 176),
            SizedBox(height: 42),
            Text('您的申请已提交，请耐心等待！',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
            SizedBox(height: 10),
            Text('我们将在48小时内处理您的申请！',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
          ],
        ),
      );
    }

    Widget _buildSuccessWidget() {
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(height: 1, color: XCColors.homeDividerColor),
            SizedBox(height: 38),
            Image.asset('assets/images/mine/mine_store_success.png',
                width: 197, height: 179),
            SizedBox(height: 64),
            Text('您的申请已通过，请支付相关入驻认证费用及保证金',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
            SizedBox(height: 10),
            Text('支付完成后我们为您分配商家管理中心！',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
            SizedBox(height: 30),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StorePayScreen(),
                  ),
                );
              },
              child: Container(
                width: 250,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: XCColors.themeColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Text(
                  '支付入驻费用',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CityWidgets.cityAppBar(context, '资质审核', () {
          Navigator.pop(context);
        }),
        body: widget.pass ? _buildSuccessWidget() : _buildInReviewWidget());
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
