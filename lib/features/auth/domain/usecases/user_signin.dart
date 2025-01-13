

import 'package:dartz/dartz.dart';

import '../../../../core/api_handler/failure.dart';
import '../../../../core/api_handler/success.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/auth_repo.dart';

class UserSignIn implements AsyncEitherUsecase<Success, UserSignInParams> {

  final AuthRepo _authRepo;

  UserSignIn( this._authRepo);

  @override
  Future<Either<DataCRUDFailure, Success>> call(UserSignInParams params) async{
    return await  _authRepo.signIn(email: params.email, password: params.password);
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({
    required this.email,
    required this.password,
  });
}