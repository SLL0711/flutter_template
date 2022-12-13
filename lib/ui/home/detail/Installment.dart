import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';

class InstallmentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InstallmentScreenState();
}

class InstallmentScreenState extends State<InstallmentScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _ruleItem(int index, String rule) {
      return Container(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image:
                      AssetImage('assets/images/mine/mine_tip_start_icon.png'),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover)),
          child: Text('$index',
              style:
                  TextStyle(color: XCColors.hotRuleIndexColor, fontSize: 10)),
        ),
        SizedBox(width: 8),
        Expanded(
            child: Text(rule,
                style: TextStyle(color: XCColors.tabNormalColor, fontSize: 12)))
      ]));
    }

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(context, '有关分期', () {
          Navigator.pop(context);
        }),
        body: Stack(children: [
          Container(
              height: double.infinity,
              child: SingleChildScrollView(
                  child: Container(
                      margin:
                          const EdgeInsets.only(left: 15, right: 15, top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.white,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 13),
                            Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 2,
                                            color:
                                                XCColors.bannerSelectedColor))),
                                child: Text('关于分期',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: XCColors.bannerSelectedColor,
                                        fontWeight: FontWeight.bold))),
                            SizedBox(height: 17),
                            Text(
                                '分期是雀斑为您贴心提供的信用支付工具，可以先消费再分期还款。轻松变美，毫无压力。目前支持多种分期方式，您可以根据需要选择不同的分期方式支付尾款。本产品可以使用花呗分期支付尾款。',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: XCColors.mainTextColor)),
                            SizedBox(height: 34),
                            Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 2,
                                            color:
                                                XCColors.bannerSelectedColor))),
                                child: Text('花呗分期',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: XCColors.bannerSelectedColor,
                                        fontWeight: FontWeight.bold))),
                            SizedBox(height: 20),
                            Text('分期服务',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: XCColors.mainTextColor)),
                            SizedBox(height: 10),
                            _ruleItem(1, '支持3、6、9、12期分期付款'),
                            SizedBox(height: 5),
                            _ruleItem(2,
                                '手续费说明:3期手续费2.5％，6期手续费4.5％，9期手续费6.5％，12期手续费8.8％。'),
                            SizedBox(height: 20),
                            Text('如何使用花呗分期',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: XCColors.mainTextColor)),
                            SizedBox(height: 10),
                            _ruleItem(1, '在支付宝内申请开通花呗分期服务。'),
                            SizedBox(height: 8),
                            _ruleItem(2,
                                '预约金支付完成后，在预约金支付成功页或者我的订单-待使用】中，选择订单『分期支付尾款】，选择花呗分期支付尾款。'),
                            SizedBox(height: 10),
                            _ruleItem(3, '支付完成后，到店验单消费。'),
                            SizedBox(height: 20),
                            Text('常见问题',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: XCColors.mainTextColor)),
                            SizedBox(height: 10),
                            _ruleItem(1, '花呗分期什么时候计息生效？'),
                            SizedBox(height: 5),
                            _ruleItem(2, '支付成功开始计息生效，进入花呗账单'),
                            SizedBox(height: 5),
                            _ruleItem(3, '花呗分期如何还款？'),
                            SizedBox(height: 5),
                            _ruleItem(4, '花呗分期的账单喝花呗账单在一起，可到支付宝内还款。'),
                            SizedBox(height: 80)
                          ])))),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: XCColors.bannerSelectedColor,
                  child: Text('进入我的分期',
                      style: TextStyle(color: Colors.white, fontSize: 16))))
        ]));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
