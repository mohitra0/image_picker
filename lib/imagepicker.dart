import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:instagrampicker/file.dart';
import 'package:storage_path/storage_path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ImagePicker(),
    );
  }
}

class ImagePicker extends StatefulWidget {
  ImagePicker({Key key, this.otherUid, this.iD, this.type}) : super(key: key);

  final String otherUid;

  final String iD;
  final String type;
  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  List<FileModel> files;
  FileModel selectedModel;
  String image;
  @override
  void initState() {
    super.initState();
    getImagesPath();
    // getVideosPath();
  }

  getImagesPath() async {
    var imagePath = await StoragePath.imagesPath;
    var images = jsonDecode(imagePath) as List;
    files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
    if (files != null && files.length > 0)
      setState(() {
        selectedModel = files[0];
        image = files[0].files[0];
      });
  }

  // getVideosPath() async {
  //   var imagePath = await StoragePath.videoPath;
  //   var images = jsonDecode(imagePath) as List;
  //   files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
  //   if (files != null && files.length > 0)
  //     setState(() {
  //       selectedModel = files[0];
  //       image = files[0].files[0];
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 20),
                    selectedModel == null || selectedModel.files.length < 1
                        ? Container()
                        : DropdownButtonHideUnderline(
                            child: DropdownButton<FileModel>(
                            items: getItems(),
                            onChanged: (FileModel d) {
                              assert(d.files.length > 0);
                              image = d.files[0];
                              setState(() {
                                selectedModel = d;
                              });
                            },
                            value: selectedModel,
                          ))
                  ],
                ),
              ],
            ),
            // Divider(),
            // Container(
            //     height: MediaQuery.of(context).size.height * 0.45,
            //     child: image != null
            //         ? Image.file(File(image),
            //             height: MediaQuery.of(context).size.height * 0.45,
            //             width: MediaQuery.of(context).size.width)
            //         : Container()),
            Divider(),
            selectedModel == null || selectedModel.files.length < 1
                ? Container()
                : Container(
                    height: MediaQuery.of(context).size.height * 0.41,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4),
                        itemBuilder: (_, i) {
                          var file = selectedModel.files[i];
                          return GestureDetector(
                            child: Image.file(
                              File(file),
                              fit: BoxFit.cover,
                            ),
                            onTap: () {
                              setState(() {
                                image = file;
                              });
                            },
                          );
                        },
                        itemCount: selectedModel.files.length),
                  )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem> getItems() {
    return files
            .map((e) => DropdownMenuItem(
                  child: Text(
                    e.folder,
                    style: TextStyle(color: Colors.black),
                  ),
                  value: e,
                ))
            .toList() ??
        [];
  }
}

class FileModel {
  List<String> files;
  String folder;

  FileModel({this.files, this.folder});

  FileModel.fromJson(Map<String, dynamic> json) {
    files = json['files'].cast<String>();
    folder = json['folderName'];
  }
}
