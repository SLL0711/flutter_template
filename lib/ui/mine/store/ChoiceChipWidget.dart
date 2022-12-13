import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';

class ChoiceChipWidget extends StatefulWidget {
  final String text;
  final double height;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final Color textColor;
  final Color boxColor;
  final Color textSelectColor;
  final Color boxSelectColor;
  final BorderRadiusGeometry borderRadius;
  final BoxBorder border;
  final BoxBorder selectBorder;
  final ValueChanged<bool> onSelected;
  final bool selected;

  const ChoiceChipWidget(
    this.text,
    this.onSelected, {
    this.height = 30,
    this.padding = const EdgeInsets.only(
      left: 10,
      top: 7,
      right: 10,
      bottom: 7,
    ),
    this.fontSize = 14,
    this.textColor = const Color(0xFF535353),
    this.boxColor = const Color(0xFFFFFFFF),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.border = const Border.fromBorderSide(BorderSide(
        color: Color(0xFF535353), width: 1, style: BorderStyle.solid)),
    this.selectBorder = const Border.fromBorderSide(BorderSide(
        color: XCColors.themeColor, width: 1, style: BorderStyle.solid)),
    this.selected = false,
    this.textSelectColor = XCColors.themeColor,
    this.boxSelectColor = const Color(0xFFFFFFFF),
  });

  @override
  State<StatefulWidget> createState() {
    return _ChoiceChipWidgetState();
  }
}

class _ChoiceChipWidgetState extends State<ChoiceChipWidget> {
  @override
  Widget build(BuildContext context) {
    bool _select = widget.selected;

    return GestureDetector(
      onTap: () {
        widget.onSelected(!_select);
      },
      child: Container(
        height: widget.height,
        width: 120,
        padding: widget.padding,
        child: _select
            ? new Stack(
                alignment: const FractionalOffset(1, 1),
                children: <Widget>[
                  new Container(
                    width: 120,
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                        fontSize: widget.fontSize,
                        color: widget.textSelectColor,
                      ),
                    ),
                  ),
                  new Container(
                    child: Icon(
                      Icons.check,
                      color: widget.textSelectColor,
                      size: 15,
                    ),
                  )
                ],
              )
            : new Text(
                widget.text,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: widget.fontSize,
                  color: widget.textColor,
                ),
              ),
        decoration: new BoxDecoration(
          color: _select ? widget.boxSelectColor : widget.boxColor,
          borderRadius: widget.borderRadius,
          border: _select ? widget.selectBorder : widget.border,
        ),
      ),
    );
  }
}
