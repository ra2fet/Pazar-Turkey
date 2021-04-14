
import 'package:flutter/material.dart';
import 'package:pazar_app/models/realstate_model.dart';
import 'package:pazar_app/utils/app_colors.dart';

class RealEstatePopupMenu extends StatefulWidget {
  const RealEstatePopupMenu({Key key, this.list, this.controller }) : super(key: key);
    final List<RealStateModel> list ;
  final controller;
  @override
  _RealEstatePopupMenuState createState() => _RealEstatePopupMenuState();
}

class _RealEstatePopupMenuState extends State<RealEstatePopupMenu> {
  @override
  Widget build(BuildContext context) {
    var _selected;

    var _selectoption = false;


    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: PopupMenuButton(
        icon: RotatedBox(quarterTurns: 1, child: Icon(Icons.compare_arrows)),
        onSelected: (String value) {
          _selected = value;

          if(_selected == '1'){
            widget.controller.updateisPriceFilter(widget.list);
          }else{
               widget.controller.updateNewFilter(widget.list);

          }
          print(_selected);
        },
        offset: Offset(-15, 35),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
      
          
    
          CheckedPopupMenuItem(
            checked: _selected == '1',
            value: '1',
            child: widget.controller.isPriceFilter? Align(alignment:Alignment.centerRight,child: Text('حسب السعر الأقل')): Align(alignment:Alignment.centerRight,child: Text('حسب السعر الأعلى')),
          ),
          CheckedPopupMenuItem(
            checked: _selected == '2',
            value: '2',
            child: widget.controller.isNewFilter?  Align(alignment:Alignment.centerRight,child: Text('حسب الأقدم')): Align(alignment:Alignment.centerRight,child: Text('حسب الأحدث')),
          ),
        ],
      ),
    );
  }

   int mySortComparison(RealStateModel a, RealStateModel b) {
  if (a.price < b.price ) {
    return -1;
  } else if (a.price > a.price) {
    return 1;
  } else {
    return 0;
  }

}
}
