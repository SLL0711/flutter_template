import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_medical_beauty/ui/login/entity.dart';

import '../../../../api.dart';
import '../../../../empty.dart';
import '../../../../http.dart';
import '../../../../toast.dart';

class DetailRuleView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DetailRuleViewState();
}

class DetailRuleViewState extends State<DetailRuleView>
    with AutomaticKeepAliveClientMixin {
  /// 文章数据
  ArticleEntity _entity = ArticleEntity();

  @override
  void initState() {
    Future.delayed(Duration.zero, _requestData);
    super.initState();
  }

  void _requestData() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.article + 'b6jtp2gh2', context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _entity = ArticleEntity.fromJson(http.data);
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return _entity.content.isEmpty
        ? Container(
            height: double.infinity,
            child: EmptyWidgets.dataEmptyView(context),
          )
        : Container(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Html(data: _entity.content),
                  SizedBox(height: 80),
                ],
              ),
            ),
          );
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
