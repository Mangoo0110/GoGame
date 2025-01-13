
  //functions :: 
import 'dart:io';
import 'dart:typed_data';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../func/dekhao.dart';



Future<File> uint8ListToFile(Uint8List uint8List, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(uint8List);
    return file;
  }

  Future<Uint8List?> pickImage() async {
    try {
      return await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 13).then((value) async{
        dekhao(value.runtimeType);
        if(value == null) {
          dekhao("picked image is null");
          return null;
        }
        return await value.readAsBytes();
      });
      
      
    } catch (error) {
      dekhao(error.toString());
      Fluttertoast.showToast(msg: "Failed to pick image. Internal error!");
    }
    return null;
  }