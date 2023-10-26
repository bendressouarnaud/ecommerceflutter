
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:newecommerce/repositories/achat_repository.dart';

import '../models/achat.dart';

class AchatGetController extends GetxController {

  //
  var taskData = <Achat>[].obs;
  final _achatRepository = AchatRepository();
  int idart = 0;
  bool hideButton = false;
  int selection = 0;


  @override
  void onInit() {
    _getData();
    super.onInit();
  }

  void setFlag(int selection){
    this.selection = selection;
    update();
  }

  void _getData() {
    _achatRepository.findAllAchatByActif("1").then((value) {
      for (var element in value) {
        taskData.add(Achat(idach: element.idach, idart: element.idart, actif: element.actif));
      }
    });
  }

  // Made because at the START, when ITEM are already booked, application display 0 ITEMS
  void refreshMainInterface(){
    update();
  }

  void addData(int article, {int operation = 0}) async {
    // operation = 0  --> AJOUT
    // operation = 1  --> SUPPRESSION
    if(operation == 0) {
      var achat = Achat(idach: 0, idart: article, actif: 1);
      await _achatRepository.insertAchat(achat);
      taskData.insert(0, achat);
    }
    else{
      // Look for ONE OCCURRENCE to delete :
      List<Achat> lte = await _achatRepository.findAllAchatByIdartAndActif(article, 1) ;
      var idach = lte.first.idach;
      // Delete :
      await _achatRepository.deleteAchatById(idach);
      // From there :
      int idartIndex = taskData.indexWhere((element) => element.idart == article);
      if(idartIndex > -1){
        taskData.removeAt(idartIndex);
      }
    }

    // Set FLAG :
    idart = article;
    update();
    hideButton = true;

    // Set timer to
    Future.delayed(const Duration(milliseconds: 700),
      () {
        idart = 0;
        hideButton = false;
        update();
      }
    );
  }

}