import 'package:flutter/material.dart';
import 'package:friends/services/database_service.dart';


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
}
