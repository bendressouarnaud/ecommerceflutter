
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:newecommerce/repositories/achat_repository.dart';

import '../models/achat.dart';

class AchatGetController extends GetxController {

  //
  var taskData = <Achat>[].obs;
  final _achatRepository = AchatRepository();


  @override
  void onInit() {
    _getData();
    super.onInit();
  }

  void _getData() {
    _achatRepository.findAllAchatByActif("0").then((value) {
      for (var element in value) {
        taskData.add(Achat(idach: element.idach, idart: element.idart, actif: element.actif));
      }
    });
  }

  void addData(int article) async {
    var achat = Achat(idach: 0, idart: article, actif: 0);
    await _achatRepository.insertAchat(achat);
    taskData.insert(0, achat);
    update();
  }

}