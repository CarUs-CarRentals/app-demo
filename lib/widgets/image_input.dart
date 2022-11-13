import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  const ImageInput(this.onSelectImage, {Key? key}) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  UploadTask? uploadTask;
  File _storedImage = File('');
  final _firebaseStorage = FirebaseStorage.instance;

  _uploadImage() async {
    final fileName =
        _storedImage.path.substring(_storedImage.path.lastIndexOf('/'));
    final path = 'images/userid/carid/${fileName}';

    final ref = _firebaseStorage.ref().child(path);
    uploadTask = ref.putFile(_storedImage);

    final snapshot = await uploadTask!.whenComplete(() => null);

    final urlDownload = await snapshot.ref.getDownloadURL();
    print(urlDownload);
  }

  _takePicture() async {
    final ImagePicker _picker = ImagePicker();
    XFile imageFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    ) as XFile;

    setState(() {
      _storedImage = File(imageFile.path);
    });

    //widget.onSelectImage(...);
  }

  _getFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    ) as XFile;

    setState(() {
      _storedImage = File(imageFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 180,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              alignment: Alignment.center,
              child: _storedImage.path != ''
                  ? Image.file(
                      _storedImage,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Text("Nenhuma Imagem"),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextButton.icon(
                onPressed: _takePicture,
                icon: Icon(Icons.camera),
                label: Text("Tirar foto"),
              ),
            ),
            Expanded(
              child: TextButton.icon(
                onPressed: _getFromGallery,
                icon: Icon(Icons.photo),
                label: Text("Galeria"),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: _uploadImage,
                icon: Icon(Icons.upload),
                label: Text("Upload"),
              ),
            ),
          ],
        )
      ],
    );
  }
}
