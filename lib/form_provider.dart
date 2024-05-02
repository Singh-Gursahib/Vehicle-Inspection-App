// form_provider.dart

import 'package:flutter/material.dart';
import 'vehicle_inspection_form.dart';

class FormProvider extends ChangeNotifier {
  VehicleInspectionForm _form = VehicleInspectionForm();

  VehicleInspectionForm get form => _form;

  void updateForm(VehicleInspectionForm newForm) {
    _form = newForm;
    notifyListeners();
  }
}
