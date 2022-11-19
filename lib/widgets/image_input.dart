import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  final String urlImage;
  final double radius;
  const ImageInput(this.onSelectImage, this.urlImage, this.radius, {Key? key})
      : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  UploadTask? uploadTask;
  File _storedImage = File('');
  final _firebaseStorage = FirebaseStorage.instance;
  String _lastUrlImage = '';

  // _uploadImage() async {
  //   final fileName =
  //       _storedImage.path.substring(_storedImage.path.lastIndexOf('/'));
  //   final path = 'images/userid/carid/${fileName}';

  //   final ref = _firebaseStorage.ref().child(path);
  //   uploadTask = ref.putFile(_storedImage);

  //   final snapshot = await uploadTask!.whenComplete(() => null);

  //   final urlDownload = await snapshot.ref.getDownloadURL();
  //   print(urlDownload);
  // }

  _takePicture() async {
    final ImagePicker _picker = ImagePicker();
    XFile imageFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
    ) as XFile;

    setState(() {
      _storedImage = File(imageFile.path);
    });

    _getStoredImage();
  }

  _getFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
    ) as XFile;

    setState(() {
      _storedImage = File(imageFile.path);
    });

    _getStoredImage();
  }

  _removePicture() {
    _getStoredImage();

    setState(() {
      _storedImage = File('');
    });
  }

  _getStoredImage() {
    if (widget.urlImage != "" && widget.urlImage != _lastUrlImage) {
      print("url da imagem: ${widget.urlImage}");
      _lastUrlImage = widget.urlImage;
      _storedImage = File(widget.urlImage);
    }
    widget.onSelectImage(_storedImage);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getStoredImage();
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
            _storedImage.path != '' && !_storedImage.path.startsWith("https://")
                ? ClipRRect(
                    borderRadius:
                        BorderRadius.all(Radius.circular(widget.radius)),
                    child: Image.file(
                      _storedImage,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : _storedImage.path.startsWith("https://")
                    ? ClipRRect(
                        borderRadius:
                            BorderRadius.all(Radius.circular(widget.radius)),
                        child: Image.network(
                          _storedImage.path,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(widget.radius)),
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
