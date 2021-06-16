import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:friends/services/database_service.dart';
import 'package:image_picker/image_picker.dart';



class MessageSenderTile extends StatefulWidget {
  final String groupId;
  final String userName;
  final String groupName;
  const MessageSenderTile(
      {Key key, this.groupId, this.userName, this.groupName})
      : super(key: key);

  @override
  _MessageSenderTileState createState() => _MessageSenderTileState();
}

class _MessageSenderTileState extends State<MessageSenderTile> {

  TextEditingController messageEditingController = new TextEditingController();
  bool hasMessage = false;
  File imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = "";

  _sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sender": widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }
  Future _getImage() async {
    ImagePicker imagePicker = ImagePicker();

   var pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile();
      }
    }
  }

  /*Future uploadFile() async {
    String fileName = id;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          Firestore.instance
              .collection('users')
              .document(id)
              .updateData({
            'nickname': nickname,
            'aboutMe': aboutMe,
            'photoUrl': photoUrl
          }).then((data) async {
            await prefs.setString('photoUrl', photoUrl);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }*/
  


  /*Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
   StorageReference storageReference = FirebaseStorage.instance.ref().child(fileName);
    //StorageUploadTask uploadTask = await storageReference.putFile(imageFile);

    try {
      //TaskSnapshot snapshot = await uploadTask;
       storageReference.putFile(imageFile);

      imageUrl = await storageReference.getDownloadURL()
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    } catch (FirebaseException e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }*/
 /* void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      firebase_storage.FirebaseStorage.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send', backgroundColor: Colors.black, textColor: Colors.red);
    }
  }

*/
  @override
  void initState() {
    super.initState();
    messageEditingController.addListener(() {
      //here you have the changes of your textfield
      if (messageEditingController.text.isNotEmpty)
        hasMessage = true;
      else
        hasMessage = false;
      //use setState to rebuild the widget
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(6),
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                //color: Colors.grey[700],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Send a message ...",
                            hintStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    Visibility(

                     child: IconButton(onPressed: (){
                       print(" attached clicked");
                     },
                       icon: Icon(Icons.attach_file, color: Colors.white,),
                       iconSize: 40,
                       
                     ),
                     /* child: GestureDetector(
                        onTap: () {
                          _sendMessage();
                        },
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                              child:
                                  Icon(Icons.attach_file, color: Colors.white)),
                        ),
                      ),*/
                    ),
                    Visibility(
                      visible:! hasMessage,
                        child: IconButton(
                            onPressed: () {
                              print(" on Camera clicked");
                            },
                            color: Colors.white,
                            iconSize: 40,
                            icon: Icon(Icons.photo_camera)))
                  ],
                ),
              ),
            ),
            Visibility(
              visible: hasMessage,
              child: GestureDetector(
                onTap: () {
                  _sendMessage();
                  print(" on message send");
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(child: Icon(Icons.send, color: Colors.white)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void uploadFile() {}


}
