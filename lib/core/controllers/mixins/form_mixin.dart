import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:offline_first/ui/widgets/unsaved_form_dialog.dart';

mixin FormMixin {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  final RxBool _formWasEdited = RxBool(false);

  bool get formWasEdited => _formWasEdited.value;

  set formWasEdited(value) => _formWasEdited.value = value;

  final RxBool _autoValidate = RxBool(false);

  bool get autoValidate => _autoValidate.value;

  void formOnChanged(Map<String, dynamic> map) {
    formWasEdited = true;
  }

  Future<bool> formOnWillPop() async {
    Get.focusScope.unfocus();

    if (!formWasEdited) {
      return true;
    }

    var result = await Get.dialog(UnsavedFormDialog());

    return result as bool;
  }

  bool validateForm() {
    if (!formKey.currentState.validate()) {
      _autoValidate.value = true;

      return false;
    }

    formKey.currentState.save();

    return true;
  }

  void resetForm() {
    formKey.currentState.reset();
  }

  dynamic getFieldValue(dynamic field) {
    return formKey.currentState.fields[field]?.currentState?.value;
  }
}