

import 'package:gogame/core/utils/func/dekhao.dart';
import 'package:flutter/material.dart';
import 'package:gogame/features/image/domain/repositories/image_repo.dart';

import '../../../../init_dependency.dart';
import '../../domain/usecases/fetch_image.dart';
import '../../domain/usecases/fetch_image_from_local_db.dart';

class ImageReadProvider extends ChangeNotifier{
  

  ImageReadProvider();

  Future<ImageX?> fetchImage({required String imageUrl, bool? forceFetch, bool fromLocalDb = false})async{
    
    dekhao("imageUrl is $imageUrl");
    if(imageUrl.isEmpty) return null;

    if(fromLocalDb) {
      return await serviceLocator<FetchImageFromLocalDb>().call(FetchImageFromLocalDbParams(url: imageUrl)).then((value) {
        return value.fold(
          (l) {
            return null;
          }, (r) {
            return r;
          });
      });
    } else{
      return await serviceLocator<FetchImage>().call(FetchImageParams(url: imageUrl, forceFetch: false)).then((value) {
          return value.fold(
            (l) {
              return null;
            }, (r) {
              return r;
            });
      });
    }
    
  }

}