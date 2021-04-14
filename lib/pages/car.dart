import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as f;

import 'package:get/get.dart';
import 'package:pazar_app/models/location_model.dart';
import 'package:pazar_app/pages/details/car_details.dart';
import 'package:pazar_app/providers/requests.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/widgets/rbutton.dart';

class Car extends StatelessWidget {
  TextEditingController pickupDate =
      TextEditingController(text: DateTime.now().toString());
  TextEditingController dropoutDate = TextEditingController(
      text: DateTime.now().add(Duration(days: 3)).toString());

  TextEditingController _pickuplocation = TextEditingController();

  TextEditingController _dropoutlocation = TextEditingController();

  TextEditingController _carName = TextEditingController();
  TextEditingController _carType = TextEditingController();
  TextEditingController _carEngine = TextEditingController();

  List<String> fuelTypeList = <String>[ "بنزين", "ديزيل"];
  List<String> carTypeList = <String>[ "BMW", "أودي", "فراري"];
  List<String> engineTypeList = <String>[ "عادي", "اتوماتيك"];

  List<String> locationList = <String>[
    "مدينة ازمير - المطار المحلي",
    "مدينة ازمير - المطار الدولي",
    "مطار اسطنبول"
  ];

  String mypickuplocation , mydropofflocation , mycarselection,mycartype,mycarengine;
 var difference;


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("حجز السيارات"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        height: size.height,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.03,
              ),

              /*     LocationBtn(
                label: "Pick up point",
              ), */


              dropdownList(locationList, "نقطة الاستلام", _pickuplocation,"اختر نقطة الاستلام"),

              DateField(
                pickupDate: pickupDate,
                size: size,
                hintDate: "Pick up date",
                hintTime: "Pick up time",
              ),


              dropdownList(locationList, "نقطة التسليم", _dropoutlocation,    "اختر نقطة التسليم"),

              /*    LocationBtn(
                label: "Drop out point",
              ),
 */
              DateField(
                pickupDate: dropoutDate,
                size: size,
                hintDate: "Drop out date",
                hintTime: "Drop out time",
              ),

              SizedBox(
                height: size.height * 0.03,
              ),
/*               dropdownList(
                  carTypeList, "نوع السيارة", _carName, "اختر نوع السيارة"),

              dropdownList(
                  fuelTypeList, "نوع الوقود", _carType, "اختر نوع الوقود"),

              dropdownList(
                  engineTypeList, "نوع المحرك", _carEngine, "اختر نوع المحرك"),
 */


              SizedBox(
                height: size.height * 0.05,
              ),

              RButton(
                txt: "البحث",
                press: () => searchCar(),
                width: 0.8,
                btnColor: primaryColor,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),

              //  CarItem(),
            ],
          ),
        ),
      ),
    );
  }

  Widget dropdownList(typeList, label, controller, hinttext) {
    return Directionality(
      textDirection: f.TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 0.4, 0.7, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.grey[300].withAlpha(800),
              Colors.grey[200].withAlpha(500),
              Colors.grey[200].withAlpha(400),
              Colors.grey[200].withAlpha(100),
            ],
          ),
        ),
        child: DropdownSearch<Location>(
          searchBoxController: controller,
          dropdownSearchDecoration: InputDecoration(contentPadding: EdgeInsets.only(right:10),border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)))),
          searchBoxDecoration: InputDecoration(
            hintText: hinttext,hintTextDirection: f.TextDirection.rtl,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.only(right: 5),
            suffixIcon: Icon(
              Icons.search,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          popupTitle: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              hinttext,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          //popupItemBuilder: _customPopupItemBuilder ,
          showSearchBox: true,
        //  items: typeList,
          onFind: (String filter) => Requests.getLocations(filter),
          label: label,
          onChanged: (Location v) {
              
                
             if(controller == _pickuplocation)
            mypickuplocation = v.name;

            if(controller == _dropoutlocation)
            mydropofflocation = v.name;

         /*   if(controller == _carName)
            mycarselection = v;

            if(controller == _carType)
            mycartype = v;
            if(controller == _carEngine)
            mycarengine = v;

            print(mycarselection); */
          },
        ),
      ),
    );
  }

  void searchCar() {
    var now = DateTime.now();



    var date1 = DateTime.parse(pickupDate.text);
    var date2 = DateTime.parse(dropoutDate.text);

    var inputDate1 = DateFormat('dd/MM/yyyy - HH:mm').format(date1);
    var inputDate2 = DateFormat('dd/MM/yyyy - HH:mm').format(date2);

     difference = date2.difference(date1).inDays;



        final differenceWithToday = date1.difference(now).inDays;
    print(difference);
    print(differenceWithToday);

    if(mypickuplocation ==null || mydropofflocation==null){
        Constants.rSnackbarError("رسالة خطأ", "يجب تحديد مكان نقطة الاستلام والتسليم");

    }
   else if(pickupDate.text.isEmpty || dropoutDate.text.isEmpty){

        Constants.rSnackbarError("رسالة خطأ", "يجب تحديد تاريخ الاستلام والتسليم");


    }else if(differenceWithToday < 0){
        Constants.rSnackbarError("رسالة خطأ", "لا يمكن أن يكون تاريخ الاستلام أصغر من تاريخ اليوم");

    }
 else if(date1.compareTo(date2) > 0){

        Constants.rSnackbarError("رسالة خطأ", "لا يمكن أن يكون تاريخ الاستلام أكبر من تاريخ التسليم");


      print("error bigger than date2");
 
  } else if (difference < 3) {

        Constants.rSnackbarError("رسالة خطأ", "يجب أن لا تقل المدة على 3 أيام بين تاريخ الاستلام و تاريخ التسليم");


      print("error less than 3");
    }else{
        //Get.to(CarDetails(name: mycarselection ,type: mycartype,engine: mycarengine, days: difference,));
        Get.to(CarDetails( days: difference,pickupdate:inputDate1.toString(),dropoffdate:inputDate2.toString(),locationfrom:mypickuplocation , locationto:mydropofflocation));

    }

  }
}

class DateField extends StatelessWidget {
  const DateField({
    Key key,
    @required TextEditingController pickupDate,
    @required this.size,
    this.hintDate,
    this.hintTime,
  })  : _pickupDate = pickupDate,
        super(key: key);

  final TextEditingController _pickupDate;
  final Size size;
  final String hintDate;
  final String hintTime;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                border:
                    Border.all(color: Colors.grey.withOpacity(0.5), width: 1)),
            child: Icon(Icons.event),
          ),
          Expanded(
            child: Container(
              height: 50,
              child: DateTimePicker(textAlign: TextAlign.center,
                controller: _pickupDate, timeHintText: "Pick up Time",
                dateHintText: hintDate,
                type: DateTimePickerType.dateTimeSeparate,
                calendarTitle: hintDate,
                decoration: InputDecoration(contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(),
                ),
                      dateMask: 'dd/MM/yyyy',
                timeFieldWidth: size.width / 2 - 50,
                //  initialValue: DateTime.now().toString(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                //     dateLabelText: 'Pick up Date',
                //    timeLabelText: "Pick up Time",
                /* selectableDayPredicate: (date) {
    // Disable weekend days to select from the calendar
    if (date.weekday == 6 || date.weekday == 7) {
      return false;
    }

    return true;
  },*/
                onChanged: (val) => print(val),
                validator: (val) {
                  print(val);
                  return null;
                },
                onSaved: (val) => print(val),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

  Widget _customPopupItemBuilder(
      BuildContext context, list, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(list,textAlign: TextAlign.right,),
      
      ),
    );
  }
