import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:friends/services/database_service.dart';
import 'package:friends/widgets/message_sender_tile.dart';
import 'package:friends/widgets/message_tile.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String userName;
  final String groupName;

  ChatPage({this.groupId, this.userName, this.groupName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot> _chats;
  // TextEditingController messageEditingController = new TextEditingController();
  bool isLoading =false;

  Widget _chatMessages() {
    return StreamBuilder(
      stream: _chats,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return  snapshot.hasData? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (BuildContext context, int index) {

            var data = snapshot.data.docs[index];
            return MessageTile(
              sender: data['sender'],
              message: data['message'],
              sentByMe: widget.userName==data['sender'],
            );
          },):Container(
          child: Center(
            child: Text(" No data now"),
          )
        );
      },
    );
  }




  @override
  void initState() {
    super.initState();
     DatabaseService().getChats(widget.groupId).then((val) {
      // print(val);
      setState(() {
        _chats = val;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black87,
        elevation: 0.0,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            _chatMessages(),
            MessageSenderTile(
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: widget.userName,
            )
            // Container(),
          ],
        ),
      ),
    );
  }
}
