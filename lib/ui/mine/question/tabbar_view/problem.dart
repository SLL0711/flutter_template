import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/mine/question/dialog.dart';
import 'package:flutter_medical_beauty/ui/mine/question/tabbar_view/ask.dart';
import 'package:flutter_medical_beauty/ui/mine/question/widgets.dart';

import '../../../../colors.dart';

class QuestionProblemScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QuestionProblemScreenState();
}

class QuestionProblemScreenState extends State<QuestionProblemScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        Container(
          color: XCColors.homeDividerColor,
          child: Column(
            children: [
              Container(
                  height: 10,
                  width: double.infinity,
                  color: XCColors.homeDividerColor),
              Expanded(
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return QuestionWidgets.problemItem(context, index, () {
                      QuestionDialog.showDeleteDialog(context);
                    });
                  },
                ),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 85,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AskScreen()));
              },
              child: Container(
                width: 110,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: XCColors.bannerSelectedColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: XCColors.questionButtonShadowColor,
                        blurRadius: 20)
                  ],
                ),
                child: Text(
                  '去提问',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
