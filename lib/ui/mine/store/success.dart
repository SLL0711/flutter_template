import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';

class StoreSuccessScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StoreSuccessScreenState();
}

class StoreSuccessScreenState extends State<StoreSuccessScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _buildSuccessWidget() {
      return Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(children: [
            Container(height: 1, color: XCColors.homeDividerColor),
            SizedBox(height: 60),
            // Image.asset('assets/images/mine/mine_store_success.png',
            //     width: 197, height: 179),
            Container(width: 264, height: 177, child: Image.asset('assets/images/mine/mine_store_pay_success.png',
                fit: BoxFit.cover)),
            SizedBox(height: 44),
            Text('入驻费用支付成功！',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
            SizedBox(height: 10),
            Text('请联系客服获取您的商家管理中心信息。',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
            SizedBox(height: 30),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Container(
                    width: 250,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: XCColors.bannerSelectedColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text('400-666-8888',
                        style: TextStyle(color: Colors.white, fontSize: 16))))
          ]));
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CityWidgets.cityAppBar(context, '支付成功', () {
          Navigator.pop(context);
        }),
        body: _buildSuccessWidget());
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
