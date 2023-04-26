import 'package:get/get.dart';

class ErrorController extends GetxController{
  bool errorOcurredWhileFetchingData = false;

  void errorDetected(){
    errorOcurredWhileFetchingData = true;
    update();
  }

  void everythingWentFineFetchingDate(){
    errorOcurredWhileFetchingData = false;
    update();
  }
}