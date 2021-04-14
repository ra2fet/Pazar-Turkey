import 'package:flutter/material.dart';


class SearchBox extends StatelessWidget {
  SearchBox(  {Key key, this.controller, this.changed,}): super(key: key);
 final controller;
final Function changed;

  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: TextField(
                controller: controller,
                textAlign: TextAlign.end,onChanged: changed,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "بحث",
                  contentPadding: EdgeInsets.zero,
                  suffixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1.5, color: Colors.grey[300])),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Colors.grey[300])),
                ),
              ),
    );
  }
}

