import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';



import 'dart:io';
class SendInfo extends StatefulWidget {
  @override
  State<SendInfo> createState() => _SendInfoState();
}

class _SendInfoState extends State<SendInfo> {
  
   PlatformFile? pickedFile;
List<File>? imageFiles;
bool datauploading = false;

Future uploadFiles(BuildContext context) async {
  setState(() {
    datauploading = true;
  });
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("uploading start. Wait some seconds.")));
  var urls =await Future.wait(imageFiles!.map((_image) => uploadFile(_image))).then((value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Images are uploaded")));
    setState(() {
      datauploading = false;
    });
  });
  print(urls);
}

 Future selectFile(BuildContext context) async {
  

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true
    );

    if (result == null) return null;

    if(result != null){
      print('see');
    }

     imageFiles = result.paths.map((path) => File(path!)).toList();
     setState(() {
       
     });
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Images are ready to upload")));
   
  }


Future uploadFile(File image) async{
  String pathName = image.path.replaceAll(RegExp(r'[^\w\s]+'),'');
  final stringm = DateTime.now().microsecondsSinceEpoch;
  final path = 'files/$pathName$stringm';
  final ref = FirebaseStorage.instance.ref().child(path);
  
try {
  await ref.putFile(image);
 // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("uploaded succesfully")));
} on FirebaseException catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error while uploading")));
  print('error: ${e.toString()}');
}
  
  
    
  

}


Future pickImageFromCamera() async{
var image = await ImagePicker().pickImage(source: ImageSource.camera,);
File file = File(image!.path);
imageFiles!.add(file);
setState(() {
  
});
}

  
  final FirebaseStorage storage = FirebaseStorage.instance;
final _fireStore = FirebaseFirestore.instance;
var textController = TextEditingController();
  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Page"),
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 100),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    controller: textController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Type your Order Here',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Colors.black), //<-- SEE HERE
                      ),
                      focusedBorder:  OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Colors.black), //<-- SEE HERE
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: ElevatedButton(
                      onPressed: () {
                          selectFile(context);
                      },
                      child: Text('Select Images From Gallery'),
                      style: ButtonStyle(
                        
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                       
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red))))),
                  height: 80,
                ),
                SizedBox(height: 20,),
                  Container(
                  child: ElevatedButton(
                      onPressed: pickImageFromCamera,
                          
                    
                      child: Text('Pick Image from camera'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red))))),
                  height: 80,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () => uploadFiles(context) ,

                         

                    
                    child: Text(
                      'Submit',
                    ),
                  ),
                ),
                Divider(),
                 imageFiles != null?Container(
                  height: 300,
                   child: ListView(
                     
                           children: imageFiles!.map((imageone){
                              return Container(
                                 child:Card( 
                                    child: Container(
                                       height: 100, width:100,
                                       child: Image.file(File(imageone.path)),
                                    ),
                                 )
                              );
                           }).toList(),
                        ),
                 ):Container()
              ],
            ),
          
          ),
            Center(
              child: datauploading ? CircularProgressIndicator(color: Colors.orange,) : Container(),
            ),
        ],
      ),
    );
  }
}
