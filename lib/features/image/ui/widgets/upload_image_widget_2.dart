// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gogame/features/image/ui/providers/image_read_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/func/dekhao.dart';
import '../../../../core/utils/image/image_loader_func.dart';
import '../../../image/ui/providers/image_write_provider.dart';

class UploadImage extends StatefulWidget {
  final double? radius;
  final String? imageUrl;
  final bool fromLocalDb;
  final Function(Uint8List pickedImage) onPick;
  const UploadImage({
    super.key,
    this.radius,
    this.imageUrl,
    this.fromLocalDb = false,
    required this.onPick,
  });

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  @override
  void initState() {
    // TODO: implement initState
    context.read<ImageWriteProvider>().init(referencePath: widget.imageUrl, image: null, fromLocalDb: widget.fromLocalDb);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              ClipOval(
                child: Container(
                  height: widget.radius ?? min(140, constraints.maxWidth ),
                  width: widget.radius ?? min(140, constraints.maxWidth),
                  decoration: BoxDecoration(
                    color: AppColors.context(context).textColor,
                    borderRadius: BorderRadius.circular(8000000)
                  ),
                  child: context.watch<ImageWriteProvider>().image == null 
                    ? Icon(
                        Icons.image, 
                        color: AppColors.context(context).textColor.withOpacity(.7), 
                        size: min(140, constraints.maxWidth / 2) - 6,
                      )
                    : Image.memory(context.watch<ImageWriteProvider>().image!, fit: BoxFit.cover,),
                ),
              ),
              Positioned(
                bottom: 8,
                left: min(140, constraints.maxWidth) - 40,
                child: InkWell(
                  onTap: () async{
                    await pickImage().then((value) {
                      dekhao("value fetched");
                      if(value != null && context.mounted) {
                        context.read<ImageWriteProvider>().changeImage(value);
                        widget.onPick(value);
                      }
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: AppColors.context(context).backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        backgroundColor: AppColors.context(context).accentColor,
                        child:  Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.camera_alt,
                            color: AppColors.context(context).backgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

}