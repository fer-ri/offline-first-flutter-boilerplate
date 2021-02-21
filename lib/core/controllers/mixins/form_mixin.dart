import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:offline_first/ui/widgets/unsaved_form_dialog.dart';

mixin FormMixin {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  final RxBool _formWasEdited = RxBool(false);

  bool get formWasEdited => _formWasEdited.value;

  set formWasEdited(value) => _formWasEdited.value = value;

  final Rx<AutovalidateMode> _autoValidate = Rx<AutovalidateMode>();

  AutovalidateMode get autoValidate => _autoValidate.value;

  void formOnChanged() {
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
    if (!formKey.currentState.saveAndValidate()) {
      _autoValidate.value = AutovalidateMode.always;

      return false;
    }

    return true;
  }

  void resetForm() {
    formKey.currentState.reset();
  }

  dynamic getFieldValue(dynamic field) {
    return formKey.currentState.value[field];
  }
}