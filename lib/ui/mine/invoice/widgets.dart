import 'package:flutter/material.dart';

import '../../../colors.dart';

abstract class InvoiceWidgets {
  /// ===== 个人 =====
  static personItem(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1, color: XCColors.invoiceBorderColor)),
      child: Row(
        children: [
          Container(
            width: 70,
            child: Text('单位名称',
                style: TextStyle(fontSize: 16, color: XCColors.mainTextColor)),
          ),
          SizedBox(width: 24),
          Expanded(
              child: Text('个人',
                  style:
                      TextStyle(fontSize: 16, color: XCColors.mainTextColor)))
        ],
      ),
    );
  }

  /// ===== 其他 =====
  static otherItem(BuildContext context, String title, String hint,
      TextEditingController controller) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: 1,
          color: XCColors.invoiceBorderColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: XCColors.mainTextColor,
              ),
            ),
          ),
          SizedBox(width: 24),
          Expanded(
              child: TextField(
            style: TextStyle(
              fontSize: 16,
              color: XCColors.mainTextColor,
            ),
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 12,
                color: XCColors.goodsGrayColor,
              ),
            ),
          ))
        ],
      ),
    );
  }
}
