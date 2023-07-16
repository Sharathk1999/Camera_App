import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:full_screen_image/full_screen_image.dart';
import '../models/image_model.dart';

class ScreenGallery extends StatelessWidget {
  const ScreenGallery({Key? key}) : super(key: key);

  void deleteImage(Box<ImageModel> imageBox, int index) {
    final images = imageBox.values.toList();
    final imagePath = images[index].imagePath;
    File(imagePath).deleteSync();
    imageBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    final imageBox = Hive.box<ImageModel>('imagedb');
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder<Box<ImageModel>>(
          valueListenable: imageBox.listenable(),
          builder: (context, box, _) {
            final images = box.values.toList();

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final imagePath = images[index].imagePath;
                return FullScreenWidget(
                  disposeLevel: DisposeLevel.Low,
                  child: GestureDetector(
                    onLongPress: () {
                     
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title:  Text('Delete Image',style: GoogleFonts.aclonica(color: Colors.redAccent),),
                            content:  Text('Are you sure you want to delete this image?',style: GoogleFonts.aclonica(color: Colors.black26),),
                            backgroundColor:const Color.fromARGB(255, 251, 196, 196),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); 
                                },
                                child:  Text('Cancel',style: GoogleFonts.aclonica(color: Colors.black26),),
                              ),
                              TextButton(
                                onPressed: () {
                                  deleteImage(imageBox, index);
                                  Navigator.of(context).pop(); 
                                },
                                child:  Text('Delete',style: GoogleFonts.aclonica(color: Colors.black26),),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.redAccent,
                        ),
                      ),
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      
    );
  }
}
