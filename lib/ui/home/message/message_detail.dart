import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/message/entity.dart';

import '../../../colors.dart';
import '../../../widgets.dart';

class MessageDetailScreen extends StatefulWidget {
  final NoticeEntity notice;

  MessageDetailScreen(this.notice);

  @override
  State<StatefulWidget> createState() => MessageDetailScreenState();
}

class MessageDetailScreenState extends State<MessageDetailScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// ========= 头像 =========
    /// 头像
    Widget _avatarItem() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        height: 60,
        child: Row(
          children: [
            Container(
                width: 40,
                height: 40,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: widget.notice.icon == ''
                    ? Image.asset('assets/images/home/home_notice_official.png')
                    : CommonWidgets.networkImage(widget.notice.icon)),
            SizedBox(
              width: 5,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.notice.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: XCColors.mainTextColor, fontSize: 14),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  widget.notice.createTime,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(color: XCColors.tabNormalColor, fontSize: 11),
                )
              ],
            )),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CityWidgets.cityAppBar(context, '消息', () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _avatarItem(),
            Container(height: 1, color: XCColors.messageChatDividerColor),
            Container(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 5),
              child: Html(data: widget.notice.content),
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
