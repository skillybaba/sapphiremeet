import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelect {
  var context;
  var selecttype;
  ImageSelect({context, selecttype='gallery'}) {
    this.context = context;
    this.selecttype = selecttype;
  }
  image() async {
    var picker = ImagePicker();
    var image;
    if (this.selecttype == 'camera')
      image = await picker.getImage(source: ImageSource.camera);
    else
      image = await picker.getImage(source: ImageSource.gallery);

    var crop = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.yellow[800],
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    return crop;
  }
}
