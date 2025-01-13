import 'package:dartz/dartz.dart';

import '../../../../core/api_handler/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../repositories/auth_repo.dart';

class UserSignUp implements AsyncEitherUsecase<UserAuth, UserSignUpParams> {
  final AuthRepo _authRepo;

  UserSignUp( this._authRepo);

  @override
  Future<Either<DataCRUDFailure, UserAuth>> call(UserSignUpParams params) async{
    return await  _authRepo.signUp(email: params.email, password: params.password);
  }
}

class UserSignUpParams {
  final String email;
  final String password;

  UserSignUpParams({
    required this.email,
    required this.password,
  });
}