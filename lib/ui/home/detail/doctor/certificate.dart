import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';

import '../../../../colors.dart';

class DoctorCertificateView extends StatefulWidget {
  final DoctorItemEntity entity;

  DoctorCertificateView(this.entity);

  @override
  State<StatefulWidget> createState() => DoctorCertificateViewState();
}

class DoctorCertificateViewState extends State<DoctorCertificateView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _buildItem(DoctorProjectEntity projectEntity) {
      return Container(
          color: Colors.white,
          child: Column(children: [
            Container(height: 10, color: XCColors.homeDividerColor),
            SizedBox(height: 14),
            Text(projectEntity.certificateName,
                style: TextStyle(fontSize: 16, color: XCColors.mainTextColor)),
            SizedBox(height: 10),
            Container(
                height: 236,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child:
                    CommonWidgets.networkImage(projectEntity.certificateUrl)),
            SizedBox(height: 20)
          ]));
    }

    return Container(
        color: XCColors.homeDividerColor,
        child: widget.entity.doctorCertificateVOS.isEmpty
            ? Container()
            : ListView.builder(
                itemCount: widget.entity.doctorCertificateVOS.length,
                itemBuilder: (context, index) {
                  return _buildItem(widget.entity.doctorCertificateVOS[index]);
                }));
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
