import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';

import '../../../../colors.dart';

class DoctorHonorView extends StatefulWidget {
  final DoctorItemEntity entity;

  DoctorHonorView(this.entity);

  @override
  State<StatefulWidget> createState() => DoctorHonorViewState();
}

class DoctorHonorViewState extends State<DoctorHonorView>
    with AutomaticKeepAliveClientMixin {
  List<String> _honorList = <String>[];

  @override
  void initState() {
    super.initState();

    _honorList = widget.entity.honorUrl.split(',');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
        color: Colors.white,
        child: _honorList.isEmpty
            ? Container()
            : Column(children: [
                Container(height: 10, color: XCColors.homeDividerColor),
                Expanded(
                    child: GridView.builder(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 20, bottom: 20),
                        itemCount: _honorList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              child: CommonWidgets.networkImage(
                                  _honorList[index]));
                        }))
              ]));
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
