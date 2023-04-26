import 'package:get/get.dart';

class ErrorController extends GetxController{
  bool errorOcurredWhileFetchingData = false;

  void errorDetected(){
    errorOcurredWhileFetchingData = true;
    update();
  }

  void resetErrorOcurredWhileFetchingData(){
    errorOcurredWhileFetchingData = false;
    update();
  }
}