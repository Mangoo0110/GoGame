import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/common/widgets/text_widgets.dart';
import '../../../../core/utils/constants/app_colors.dart';


class UploadImage extends StatefulWidget {
  final Function (Uint8List pickedImage) onPick;
  const UploadImage({required this.onPick, super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  Uint8List? image;

  //functions :: 
  Future<File> uint8ListToFile(Uint8List uint8List, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(uint8List);
    return file;
  }

  Future<Uint8List?> pickImage(Uint8List? image) async{
    try {

      final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 13);
      if(returnedImage == null) return null;

      return File(returnedImage.path).readAsBytesSync();
       
    } catch (error) {
      Fluttertoast.showToast(msg: "Failed to pick image. Internal error!");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: InkWell(
              onTap: () async{

                image = await compute(pickImage, image);
                if(image != null) widget.onPick(image!);
                
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(Icons.file_copy, color: AppColors.context(context).textColor,),
                  ),
                  TextWidgets(context).buttonMedium(buttonText: 'Browse files', textColor: AppColors.context(context).accentColor),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}