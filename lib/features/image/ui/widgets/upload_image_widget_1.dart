// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import '../../../../core/utils/constants/app_colors.dart';
// import 'upload_image.dart';

// class ImageShowUploadWidget extends StatefulWidget {
//   final String? heroTagForImage;
//   final Uint8List? image;
//   final void Function (Uint8List image) onUpload;
//   const ImageShowUploadWidget({super.key, required this.heroTagForImage, required this.image, required this.onUpload});

//   @override
//   State<ImageShowUploadWidget> createState() => _ImageShowUploadWidgetState();
// }

// class _ImageShowUploadWidgetState extends State<ImageShowUploadWidget> {
//   Uint8List? thisImage;
//   @override
//   void initState() {
//     // TODO: implement initState
//     thisImage = widget.image;
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: constraints.maxHeight - 2,
//               width:  constraints.maxWidth/2 - 2,
//               child: Padding(
//                 padding: const EdgeInsets.all(6.0),
//                 child: _image(thisImage),
//               )),
//             SizedBox(
//               height: constraints.maxHeight, 
//               width: constraints.maxWidth/2,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: UploadImage(
//                   onPick: (pickedImage) {
//                     setState(() {
//                       thisImage = pickedImage;
//                       widget.onUpload(pickedImage);
//                     });
//                   },
//                 )
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }


//   Widget _image(Uint8List? image){
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Container(
//           height: constraints.maxHeight, 
//           width: constraints.maxWidth, 
//           decoration: BoxDecoration(
//             color: AppColors.context(context).backgroundColor,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: AppColors.context(context).backgroundColor.withOpacity(.5), width: 1)
//           ),
//           child: image == null 
//             ? Icon(Icons.image, size: 100, color: AppColors.context(context).backgroundColor.withOpacity(.4),) 
//             : Image.memory(image, fit: BoxFit.fill,),
//         );
//       },
//     );
//   }

// }