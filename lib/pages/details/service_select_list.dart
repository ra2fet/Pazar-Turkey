import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar_app/models/services_model.dart';
import 'package:pazar_app/pages/details/servicedetail.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/widgets/imagenetwork.dart';
import 'package:pazar_app/widgets/rchip.dart';

class ServiceSelectList extends StatefulWidget {
  final title;
  final int sid;
  final color;

  const ServiceSelectList({Key key, this.title, this.sid, this.color= primaryColor }) : super(key: key);

  @override
  _ServiceSelectListState createState() => _ServiceSelectListState();
}

class _ServiceSelectListState extends State<ServiceSelectList> {
  List<ServicesDetailsModel> serviceSelectList = [];

    bool loading = true;

  Future<List<ServicesDetailsModel>> getListServices(id) async {

        var response = await Constants.getUrl("api/service_types/get_all");
    
     if (response.statusCode == 200) {

       var body = jsonDecode(response.body);


    for (var item in body["data"]) {
      serviceSelectList.add(ServicesDetailsModel.fromJson(item));
    }

    serviceSelectList.retainWhere((s) => s.s_id == id);

    return serviceSelectList;
     }
     return null;
  }



  @override
  void initState() {
print("sid is  ${widget.sid}");
  if(widget.sid== 3){
    filterBtn(1);
             
  }else{
       getListServices(widget.sid).then((value) {
        setState(() {
          serviceSelectList = value;
          loading = false;
        });
      });
  }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor:  widget.color,
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: loading? Center(child:CircularProgressIndicator()):   Column(
          children: [
 
                if(widget.sid == 3)
                
                  Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        RChip(
                          txt: "الجامعات الخاصة",
                          press: () => filterBtn(1),
                          width: 0.4,
                          btnColor: btnBlue,
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        RChip(
                          txt: "الجامعات الحكومية",
                          press: () => filterBtn(2),
                          width: 0.4,
                          btnColor: btnBlue,
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        RChip(
                          txt: "المنح الدراسية",
                          press: () => filterBtn(3),
                          width: 0.4,
                          btnColor: btnBlue,
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        RChip(
                          txt: "القبول والتسجيل الحكومي",
                          press: () => filterBtn(4),
                          width: 0.5,
                          btnColor: btnBlue,
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        RChip(
                          txt: "معادلة الشهادة",
                          press: () => filterBtn(5),
                          width: 0.4,
                          btnColor: btnBlue,
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        RChip(
                          txt: "الامتحانات الدولية",
                          press: () => filterBtn(6),
                          width: 0.4,
                          btnColor: btnBlue,
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        RChip(
                          txt: "التسجيل الجامعي",
                          press: () => filterBtn(7),
                          width: 0.4,
                          btnColor: btnBlue,
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        RChip(
                          txt: "رسوم الدراسة للتخصصات في الجامعات الخاصة",
                          press: () => filterBtn(8),
                          width: 0.8,
                          btnColor: btnBlue,
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
                

               
        Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: loading?Center(child: CircularProgressIndicator(),): serviceSelectList.length == 0
                    ? Center(
                        child: Text("لا توجد بيانات"),
                      )
                    : ListView.builder(
                    itemCount:  serviceSelectList.length,
                    itemBuilder: (context, index) {
                      return  ResidenceItem(
                              img: serviceSelectList[index].image,
                              title: serviceSelectList[index].title,
                              subtitle: serviceSelectList[index].subtitle,
                              press: () => btnSelect(
                                  serviceSelectList[index]),
                            );
                    }),
              ),
            ),
          ],
        ));
  }

  void btnSelect(list) {
    Get.to(ServiceDetail(
      list: list,ismenu: true,

    ));
  }

	void filterBtn(cat) {
    print(cat);
     serviceSelectList.clear();

      getListServices(3).then((value) {
        setState(() {
          serviceSelectList = value;
              serviceSelectList.retainWhere((s) => s.cat == cat);
              loading = false;
        });
      });

    
  }
}

class ResidenceItem extends StatelessWidget {
  const ResidenceItem(
      {Key key,
      @required this.press,
      @required this.title,
      @required this.subtitle,
      this.img})
      : super(key: key);

  final String title, subtitle, img;
  final Function press;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: press,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                title,textAlign: TextAlign.end,
                                style: TextStyle(color: btnBlue, fontSize: 17),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(                                  
                                      subtitle,
                                      textAlign: TextAlign.end,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style:
                                          TextStyle(fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                ),
                                child: TextButton(
                                  onPressed: press,
                                  child: Text(
                                    "قراءة المزيد",
                                    style: TextStyle(color: btnYellow),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        child:
                            ClipRRect(
                                                            borderRadius: BorderRadius.circular(5),

                              child: ImageNetwork(url:"${Constants.resUrl}$img",height: size.height * 0.2),

                        
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )),
      ),
    );
  }
}
