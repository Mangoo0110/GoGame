import 'package:dartz/dartz.dart';

import '../../../../core/api_handler/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/image_repo.dart';

class FetchImage implements AsyncEitherUsecase<ImageX?, FetchImageParams>{

  final ImageRepo _imageRepo;

  FetchImage(this._imageRepo);
  @override
  Future<Either<DataCRUDFailure, ImageX>> call(FetchImageParams params) async{
    return await _imageRepo.fetchImage(url: params.url, forceFetch: params.forceFetch);
  }

}


class FetchImageParams {
  final bool? forceFetch;
  final String url;

  FetchImageParams({this.forceFetch, required this.url});
}