import 'package:flutter/material.dart';

import '../../../../colors.dart';
import '../widgets.dart';

class CommentCategoryView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CommentCategoryViewState();
}

class CommentCategoryViewState extends State<CommentCategoryView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(height: 10, color: XCColors.homeDividerColor),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return MessageWidgets.commentItem(context, index);
                },
              ),
            )
          ],
        ));
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}