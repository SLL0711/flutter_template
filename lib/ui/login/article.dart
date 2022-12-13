import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/login/entity.dart';

import '../../api.dart';
import '../../http.dart';
import '../../toast.dart';

class ArticleScreen extends StatefulWidget {
  final String articleCode;

  ArticleScreen(this.articleCode);

  @override
  State<StatefulWidget> createState() => ArticleScreenState();
}

class ArticleScreenState extends State<ArticleScreen>
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
    var http =
        await HttpManager.get(DsApi.article + widget.articleCode, context);
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CityWidgets.cityAppBar(
          context, _entity.title == '' ? '详情' : _entity.title, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Container(
          child: Html(
            data: _entity.content,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
