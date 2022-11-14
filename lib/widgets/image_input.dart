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

  _removePicture() {
    setState(() {
      _storedImage = File('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Selecione uma opção"),
                content: Text("Como deseja enviar a foto do seu carro?"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      _getFromGallery();
                      Navigator.of(context).pop();
                    },
                    child: const Text('GALERIA'),
                  ),
                  TextButton(
                    onPressed: () {
                      _takePicture();
                      Navigator.of(context).pop();
                    },
                    child: const Text('CÂMERA'),
                  ),
                ],
              );
            });
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            _storedImage.path != ''
                ? ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Image.file(
                      _storedImage,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Icon(Icons.add_a_photo,
                              size: 24, color: Colors.black),
                          padding: const EdgeInsets.symmetric(vertical: 35),
                        ),
                        Container(
                          child: Text("Adicionar"),
                        )
                      ],
                    ),
                  ),
            if (_storedImage.path != '')
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: _removePicture,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    radius: 10,
                    child: Icon(
                      Icons.close,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
