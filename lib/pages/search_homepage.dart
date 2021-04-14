import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar_app/pages/realestate.dart';
import 'package:pazar_app/pages/car.dart';
import 'package:pazar_app/pages/prayertimes.dart';
import 'package:pazar_app/pages/currency.dart';
import 'package:pazar_app/pages/weather.dart';

class SearchHomePage extends StatefulWidget {
  final type;

  const SearchHomePage({Key key, this.type}) : super(key: key);

  @override
  _SearchHomePageState createState() => _SearchHomePageState();
}

class _SearchHomePageState extends State<SearchHomePage> {
  SearchBoard _selectedItem;

  @override
  void initState() {
    super.initState();

    if (widget.type == "realstate") {
      Get.to(RealEstate());
    } else if (widget.type == "praytimes") {
            Get.to(PrayerTimes());

    } else if (widget.type == "currency") {
            Get.to(Currency());

    } else if (widget.type == "car") {
            Get.to(Car());

    } else if (widget.type == "weather") {
            Get.to(Weather());

    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Center(child: Text("Coming Soon...")),
      ),
    );
  }
}

class SearchBoard {
  SearchBoard(this.id, this.name);

  final int id;
  final String name;
}

class NoItemsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.folder_open,
          size: 24,
          color: Colors.grey[900].withOpacity(0.7),
        ),
        const SizedBox(width: 10),
        Text(
          "لا توجد نتائج للبحث",
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[900].withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class PopupListItemWidget extends StatelessWidget {
  const PopupListItemWidget(this.item);

  final SearchBoard item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        item.name,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

class SelectedItemWidget extends StatelessWidget {
  const SelectedItemWidget(this.selectedItem, this.deleteSelectedItem);

  final SearchBoard selectedItem;
  final VoidCallback deleteSelectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 4,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8,
              ),
              child: Text(
                selectedItem.name,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 22),
            color: Colors.grey[700],
            onPressed: deleteSelectedItem,
          ),
        ],
      ),
    );
  }
}
