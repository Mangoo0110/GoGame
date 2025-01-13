import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/utils/func/dekhao.dart';
import '../../../../init_dependency.dart';

import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../domain/usecases/user_signup.dart';

class RegisterProvider extends ChangeNotifier{
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  final RegExp passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$',
  );

  bool _canRegister = false;

  bool get canRegister => _canRegister;

  String get email => _email;

  String get password => _password;

  String get confirmPassword => _confirmPassword;

  void checkCanRegister(){
    dekhao("password $_password ${'\n'}confirmPassword $_confirmPassword");
    dekhao("_canRegister $_canRegister");
    if(!emailRegExp.hasMatch(_email) || !passwordRegExp.hasMatch(_password) || _password != _confirmPassword){
      _canRegister = false;
      
      notifyListeners();
    } else {
      dekhao("_canRegister");
      _canRegister = true;
      notifyListeners();
    }
    if(_password != _confirmPassword){
      dekhao("_canRegister false");
    }
    
  }

  void setEmail(String email){
    _email = email;
    checkCanRegister();
  }

  void setPassword(String password){
    _password = password.trim();
    checkCanRegister();
  }

  void setConfirmPassword(String password){
    _confirmPassword = password.trim();
    checkCanRegister();
  }


  Future<void> registerBang({
    required VoidCallback onDone
  }) async{

    await serviceLocator<UserSignUp>().call(UserSignUpParams(email: _email, password: _password)).then((value) {
      
      value.fold((l) => null, (r) async{

        UserAuth userAuth = r;
        onDone();

        //await serviceLocator<>().call().then((value) => onDone());
      });
      
    });
  }

}