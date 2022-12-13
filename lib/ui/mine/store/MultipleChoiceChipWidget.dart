import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/mine/store/entity.dart';

import 'ChoiceChipWidget.dart';

class MultipleChoiceChipWidget extends StatefulWidget {
  final List<TagEntity> strings;
  final List<int> selectList;
  final void Function(List<int>) onChanged;

  MultipleChoiceChipWidget(this.strings, this.selectList, this.onChanged);

  @override
  State<StatefulWidget> createState() {
    return _MultipleChoiceChipWidgetState();
  }
}

class _MultipleChoiceChipWidgetState extends State<MultipleChoiceChipWidget> {
  Iterable<Widget> get actorWidgets sync* {
    List<TagEntity> list = this.widget.strings;
    List<int> selectList = this.widget.selectList;
    if (ObjectUtil.isEmptyList(list)) {
      Container();
    } else {
      for (TagEntity actor in list) {
        yield Container(
          padding: EdgeInsets.only(left: 10, top: 4, right: 10, bottom: 4),
          child: ChoiceChipWidget(
            actor.tagName,
            (selected) {
              selectList.contains(actor.id)
                  ? selectList.remove(actor.id)
                  : selectList.add(actor.id);
              this.widget.onChanged(selectList);
            },
            height: 34,
            selected: selectList.contains(actor.id),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Wrap(
          children: actorWidgets.toList(),
        ),
      ],
    );
  }
}
