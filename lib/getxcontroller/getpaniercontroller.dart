
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PanierGetController extends GetxController {

  // A t t r i b u t e
  int selection = 0;


  // M e t h o d :
  @override
  void onInit() {
    super.onInit();
  }

  void setFlag(int selection){
    this.selection = selection;
    update();
  }

}