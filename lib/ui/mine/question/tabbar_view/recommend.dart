import 'package:flutter/material.dart';

import '../../../../colors.dart';
import '../widgets.dart';

class QuestionRecommendScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QuestionRecommendScreenState();
}

class QuestionRecommendScreenState extends State<QuestionRecommendScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      color: XCColors.homeDividerColor,
      child: Column(
        children: [
          Container(
              height: 10,
              width: double.infinity,
              color: XCColors.homeDividerColor),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return QuestionWidgets.recommendItem(context);
              },
            ),
          )
        ],
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
