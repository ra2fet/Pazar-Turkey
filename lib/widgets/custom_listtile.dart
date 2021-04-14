import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    @required this.thumbnail,
    @required this.title,
    @required this.subtitle,
    @required this.img,
  });

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final img;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: thumbnail,
          ),
          _Description(
            title: title,
            subtitle: subtitle,
          ),
          SvgPicture.asset(
            "assets/icons/$img.svg",
            semanticsLabel: "$img",
          ),
        ],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({
    Key key,
    this.title,
    this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}
