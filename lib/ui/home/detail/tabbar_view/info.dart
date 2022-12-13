import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';

class DetailInfoView extends StatefulWidget {
  final int id;

  DetailInfoView(this.id);

  @override
  State<StatefulWidget> createState() => DetailInfoViewState();
}

class DetailInfoViewState extends State<DetailInfoView>
    with AutomaticKeepAliveClientMixin {
  String _detailHtml = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      requestDetailInfo();
    });
  }

  void requestDetailInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.productChildren + widget.id.toString(), context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _detailHtml = http.data['detailMobileHtml'] ?? '';
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return _detailHtml.isEmpty
        ? Container(
            height: double.infinity,
            child: EmptyWidgets.dataEmptyView(context),
          )
        : Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Html(data: _detailHtml),
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
