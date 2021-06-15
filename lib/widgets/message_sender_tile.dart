import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friends/services/database_service.dart';

import 'message_tile.dart';

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
  Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();
  bool hasMessage = false;

  Widget _chatMessages() {
    return StreamBuilder(
      stream: _chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.documents[index].data["message"],
                    sender: snapshot.data.documents[index].data["sender"],
                    sentByMe: widget.userName ==
                        snapshot.data.documents[index].data["sender"],
                  );
                })
            : Container();
      },
    );
  }

  _hasMessage() {
    print(" in has message");
    return messageEditingController.text.isNotEmpty;
  }

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

  @override
  void initState() {
    super.initState();
    DatabaseService().getChats(widget.groupId).then((val) {
      // print(val);
      setState(() {
        _chats = val;
      });
    });
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
                      visible: hasMessage,
                      child: GestureDetector(
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
                      ),
                    ),
                    Visibility(
                        child: IconButton(
                            onPressed: () {},
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
}
