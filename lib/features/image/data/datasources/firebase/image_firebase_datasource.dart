
import 'dart:collection';
import 'dart:io';

import 'package:gogame/core/api_handler/exceptions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/utils/func/dekhao.dart';
import '../../../domain/repositories/image_repo.dart';


abstract interface class ImageRemoteDatasource{
  Future<ImageRemote> fetchImage({required String imageUrl, bool? forceFetch});

  Future<ImageRemote> saveImageWithUrl({required String existingImageUrl, required Uint8List image});

  Future<ImageRemote> saveImageWithReferencePath({required String referencePath, required Uint8List image});

  Future<void> deleteImage({required String imageUrl});
}

class ImageFirebaseStorageImpl implements ImageRemoteDatasource{


  final SplayTreeMap<String, ImageRemote> _images = SplayTreeMap<String, ImageRemote>();

  static ImageFirebaseStorageImpl? _instance;
  

  ImageFirebaseStorageImpl._();

  static ImageFirebaseStorageImpl get instance {
    _instance ??= ImageFirebaseStorageImpl._();
    return _instance!;
  }

  @override
  Future<void> deleteImage({required String imageUrl}) async{
    return FirebaseStorage.instance.ref(imageUrl).delete();
  }
  
  @override
  Future<ImageRemote> fetchImage({required String imageUrl, bool? forceFetch}) async{
    

    final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);

    if (kDebugMode) {
      print("path is $imageUrl ${'\n\n'}");
      print("url is ${storageRef.fullPath} ${'\n\n'}");
    }

    if(forceFetch != true && _images.containsKey(storageRef.fullPath) 
        && _images[storageRef.fullPath]!.fetchedAt.difference(DateTime.now()).inSeconds < 60 * 10
      ) {
        dekhao("image exist; url is ${storageRef.fullPath} ${'\n\n'}");
        return _images[storageRef.fullPath]!;
      }
      
    return await storageRef.getData().then((data){
      if(data == null) throw NoDataException();
      dekhao("fetched url is ${storageRef.fullPath} ${'\n\n'}");
      _images[storageRef.fullPath] = ImageRemote._(url: storageRef.fullPath, image: data);
      return ImageRemote._(url: imageUrl, image: data);
    });
  }

  @override
  Future<ImageRemote> saveImageWithUrl({required String existingImageUrl, required Uint8List image}) async{

    Reference storageRef = FirebaseStorage.instance.refFromURL(existingImageUrl);

    // Upload the file
      try {
        return await storageRef.putData(image).then((ts) async{
          if(!(ts.state == TaskState.success)) throw PathNotFoundException(storageRef.fullPath, const OSError());
          final url = await storageRef.getDownloadURL();
          final savedImage = ImageRemote._(url: url, image: image);
        _images[storageRef.fullPath] = savedImage;
        return savedImage;
        });
      } catch (e) {
        dekhao(e.toString());
        rethrow;
      }
    
  }


  @override
  Future<ImageRemote> saveImageWithReferencePath({required String referencePath, required Uint8List image}) async{
      
    // Create a storage reference
      Reference storageRef = FirebaseStorage.instance.ref().child(referencePath);


    // Upload the file
      return await storageRef.putData(image).then((ts) async{
        if(!(ts.state == TaskState.success)) throw PathNotFoundException(storageRef.fullPath, const OSError());
        final url = await storageRef.getDownloadURL();
        final savedImage = ImageRemote._(url: url, image: image);
        _images[storageRef.fullPath] = savedImage;
        return savedImage;
      });
    
  }
}




class ImageRemote extends ImageX {
  

  ImageRemote._({required super.url, required super.image,});


  @override
  bool operator ==(covariant ImageRemote other) {
    if (identical(this, other)) return true;
  
    return 
      other.url == url &&
      other.fetchedAt == fetchedAt &&
      other.image == image;
  }

  @override
  int get hashCode => url.hashCode ^ fetchedAt.hashCode ^ image.hashCode;
}
