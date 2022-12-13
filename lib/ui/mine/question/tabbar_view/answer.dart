import 'package:flutter/material.dart';

import '../../../../colors.dart';
import '../widgets.dart';

class QuestionAnswerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QuestionAnswerScreenState();
}

class QuestionAnswerScreenState extends State<QuestionAnswerScreen>
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
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return QuestionWidgets.answerItem(context);
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
            child: Container(
              width: 110,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: XCColors.bannerSelectedColor,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: XCColors.questionButtonShadowColor, blurRadius: 20)
                ],
              ),
              child: Text(
                '去回答',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
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
