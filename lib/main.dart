import 'package:camera_app/screens/screen_gallery.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';


import 'models/image_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(ImageModelAdapter().typeId)) {
    Hive.registerAdapter(ImageModelAdapter());
  }
  await Hive.openBox<ImageModel>('imagedb');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Container(
  // decoration: BoxDecoration(
  //   image: DecorationImage(
  //     image: NetworkImage('https://img.freepik.com/free-psd/digital-camera-studio-light-setup-icon-isolated-3d-render-illustration_47987-10954.jpg?w=740&t=st=1688095208~exp=1688095808~hmac=c62d476ee7a80c8bedf19d44e74c049d7157ea29cb8a6aa73aea75c68e6f743f'),
  //     fit: BoxFit.cover,
  //   ),
  // ),
  alignment: Alignment.center,
  child: Text(
    '"Photography is the story I fail to put into words." \n- Destin Sparks',
    style: GoogleFonts.aclonica(fontSize: 12),
  ),
),

  const  ScreenGallery(),
    Container(
      alignment: Alignment.center,
      child:  Text(
        'Share Screen',
        style: GoogleFonts.aclonica(fontSize: 20),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title:  Text('Camera App',style: GoogleFonts.aclonica(),),
        backgroundColor: Colors.redAccent,
        leading:const Icon(Icons.camera_outlined,size: 40,),
          
        ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items:  [
          BottomNavigationBarItem(
            icon: IconButton(onPressed: (){
              getCamera(context);
            }, icon:const Icon(Icons.camera_alt_outlined)),
            label: 'Camera',
            
          ),
          BottomNavigationBarItem(
            icon: IconButton(onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ScreenGallery(),),);
            }, icon:const Icon(Icons.photo_library)),
            label: 'Gallery',
          ),
      const    BottomNavigationBarItem(
            icon: Icon(Icons.share_outlined),
            label: 'Share',
          ),
        ],
      ),
    );
  }
  Future<void> getCamera(BuildContext context) async {
    var _image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (_image == null) {
      return;
    }

    final imagePath = _image.path;
    final imageModel = ImageModel()..imagePath = imagePath;

    final imageBox = Hive.box<ImageModel>('imagedb');
    imageBox.add(imageModel);
  }
}

