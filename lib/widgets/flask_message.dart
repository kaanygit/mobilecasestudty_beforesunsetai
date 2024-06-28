import 'package:beforesunsetai_mobile_case_study/constant/fonts.dart';
import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorMessage),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
    ),
  );
}

void showSuccessSnackBar(BuildContext context, String successMessage) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(successMessage),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.green,
  ));
}

void showAlertSnackBar(BuildContext context, String alertMessage) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      alertMessage,
      textAlign: TextAlign.center,
      style: fontStyle(
        16,
        Colors.black,
        FontWeight.bold,
      ),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.amber,
  ));
}
