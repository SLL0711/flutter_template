import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/category/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/video/video_order.dart';

class VideoPaySuccessScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VideoPaySuccessScreenState();
}

class VideoPaySuccessScreenState extends State<VideoPaySuccessScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CategoryWidgets.categoryAppBar(context, '支付提示'),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 36),
              Container(
                width: 52,
                height: 52,
                child: Image.asset('assets/images/video/video_succese.png'),
              ),
              SizedBox(height: 15),
              Text(
                '支付成功',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00C233)),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoOrderScreen(),
                        ),
                      );
                    },
                    child: Container(
                        height: 35,
                        width: 115,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white,
                            border: Border.all(color: Color(0xFFE5E5E5))),
                        child: Text(
                          '查看订单',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF999999)),
                        )),
                  ),
                  SizedBox(width: 18),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Container(
                        height: 35,
                        width: 115,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.black),
                        child: Text(
                          '返回咨询',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        )),
                  )
                ],
              )
            ],
          ),
        ));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
