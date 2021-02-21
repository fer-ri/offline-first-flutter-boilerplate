import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:offline_first/core/controllers/posts/post_form_controller.dart';

class PostFormScreen extends GetView<PostFormController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: GetX(
          builder: (_) {
            return _buildForm();
          },
        ),
      ),
      bottomNavigationBar: _buildButton(),
    );
  }

  Widget _buildForm() {
    return FormBuilder(
      key: controller.formKey,
      autovalidateMode: controller.autoValidate,
      onChanged: controller.formOnChanged,
      onWillPop: controller.formOnWillPop,
      initialValue: controller.post?.toMap(),
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'title',
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(Get.context),
            ]),
            decoration: InputDecoration(
              labelText: 'Title',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            textCapitalization: TextCapitalization.words,
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      padding: EdgeInsets.all(16),
      child: GetX(
        builder: (_) {
          VoidCallback onPressed = controller.isBusy
              ? null
              : () async {
                  try {
                    await controller.submit();
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      e.toString(),
                      snackPosition: SnackPosition.BOTTOM,
                      colorText: Colors.white,
                      backgroundColor: Colors.black.withOpacity(0.6),
                      margin: EdgeInsets.all(16),
                    );
                  }
                };

          return RaisedButton(
            elevation: 0,
            padding: EdgeInsets.all(16),
            onPressed: onPressed,
            child: Text(controller.buttonText),
          );
        },
      ),
    );
  }
}
