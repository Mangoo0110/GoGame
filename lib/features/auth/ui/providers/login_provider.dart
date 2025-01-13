import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../init_dependency.dart';
import '../../domain/usecases/user_signin.dart';

class LoginProvider extends ChangeNotifier{
  String _email = '';
  String _password = '';
  String _storeName = '';
  Uint8List? _storeImage;

  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  final RegExp passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$',
  );

  bool _canLogin = false;

  bool get canRegister => _canLogin;

  String get email => _email;

  String get password => _password;

  String get storeName => _storeName;

  Uint8List? get storeImage => _storeImage;

  void checkCanRegister(){
    if(!emailRegExp.hasMatch(_email) || _password.isEmpty){
      _canLogin = false;
      notifyListeners();
    } else {
      _canLogin = true;
      notifyListeners();
    }
  }

  void setEmail(String email){
    _email = email;
    checkCanRegister();
  }

  void setPassword(String password){
    _password = password;
    checkCanRegister();
  }

  Future<void> loginBang({
    required VoidCallback onDone
  }) async{

    await serviceLocator<UserSignIn>().call(UserSignInParams(email: email, password: password)).then((value) {
      
      value.fold((l) {
        Fluttertoast.showToast(msg: "Login failed!. ${l.message}");
      }, (r) async{
        Fluttertoast.showToast(msg: "Login successful.");
        onDone();
        // await serviceLocator<>().call(NoParams()).then((value) {
        //   value.fold((l) => null, (r) => onDone());
        // });
      });
      
    });
  }

}