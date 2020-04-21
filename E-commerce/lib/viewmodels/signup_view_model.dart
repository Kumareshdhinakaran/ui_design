import 'package:flutter/material.dart';
import 'package:udecor/constants/route_names.dart';
import 'package:udecor/locator.dart';
import 'package:udecor/services/authentication_service.dart';
import 'package:udecor/services/dialog_service.dart';
import 'package:udecor/services/navigation_service.dart';

import 'base_model.dart';

class SignUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  String _selectedRole = 'Select a User Role';
  String get selectedRole => _selectedRole;

  setSelectedRole(role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future signUp(
      {@required String email,
      @required String password,
      @required String fullName}) async {
    setBusy(true);

    var result = await _authenticationService.signUpWithEmail(
      email: email,
      password: password,
      fullName: fullName,
      role: _selectedRole,
    );

    setBusy(false);
    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(LoginViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Sign Up Failure',
          description: 'General sign up failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Sign Up Failure',
        description: result,
      );
    }
  }
}
