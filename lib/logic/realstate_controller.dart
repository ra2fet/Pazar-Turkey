import 'package:get/get.dart';
import 'package:multi_sort/multi_sort.dart';
import 'package:pazar_app/models/realstate_model.dart';

class RealStateController extends GetxController{


bool isPriceFilter = false;
bool isNewFilter = false;

  void updateisPriceFilter(List<RealStateModel> filteredRealstateList) {

    isPriceFilter = !isPriceFilter;
                    print(isPriceFilter);

       filteredRealstateList.multisort([isPriceFilter], ['price']);
       update(); // use update() to update counter variable on UI when increment be called

  }


    void updateNewFilter(List<RealStateModel> filteredRealstateList) {

    isNewFilter = !isNewFilter;
                    print(isNewFilter);

       filteredRealstateList.multisort([isNewFilter], ['id']);
       update(); // use update() to update counter variable on UI when increment be called

  }

  void setListValue(List<RealStateModel> value1,List<RealStateModel> value2){

            value1 = value2;

               update(); // use update() to update counter variable on UI when increment be called

  }

  

}