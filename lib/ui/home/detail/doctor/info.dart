import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';

import '../../../../colors.dart';

class DoctorInfoView extends StatefulWidget {
  final DoctorItemEntity entity;

  DoctorInfoView(this.entity);

  @override
  State<StatefulWidget> createState() => DoctorInfoViewState();
}

class DoctorInfoViewState extends State<DoctorInfoView>
    with AutomaticKeepAliveClientMixin {
  String _project = '';

  @override
  void initState() {
    super.initState();

    widget.entity.doctorProjectListVOS.forEach((element) {
      if (_project.isEmpty) {
        _project = element.name;
      } else {
        _project = _project + '   ' + element.name;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _buildItem(String title, String content) {
      return Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(15),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: TextStyle(fontSize: 14, color: XCColors.tabNormalColor)),
            SizedBox(width: 15),
            Expanded(
                child: Text(content,
                    style:
                        TextStyle(fontSize: 14, color: XCColors.mainTextColor)))
          ]));
    }

    return Container(
        color: XCColors.homeDividerColor,
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 10),
          Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(15),
              child: Text(widget.entity.name,
                  style:
                      TextStyle(fontSize: 16, color: XCColors.mainTextColor))),
          SizedBox(height: 1),
          _buildItem('担任职务：', widget.entity.duties),
          SizedBox(height: 1),
          _buildItem('擅长项目：', _project),
          SizedBox(height: 1),
          _buildItem('擅长项目：', widget.entity.description)
        ])));
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
