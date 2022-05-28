import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebasesetup/Services/firestoreservices.dart';
// ignore: camel_case_types
class chat extends StatefulWidget {
  final String cid; 
  // cid -- chatid
  final String username; //current user
  const chat({ Key? key , required  this.cid,required this.username}) : super(key: key);

  @override
  State<chat> createState() => _chatState(this.cid,this.username);
  
}


// ignore: camel_case_types
class _chatState extends State<chat> {
  String cid;

String username;
  _chatState( this.cid,this.username);
TextEditingController messageeditingcontroller = TextEditingController();
  Stream<QuerySnapshot>? chats;
  @override
void initState() {

   firestoreservices().getChats(cid).then((val) {
      setState(() {
        chats = val;
        //print(chats.length.toString())
      });
    });
  super.initState();
  
}
Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        return snapshot.hasData ?  ListView.builder(
          itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data!.docs[index].data()["message"],
                sendByMe: username == snapshot.data!.docs[index].data()["sendBy"],
              );
            }) : Container();
      },
    );
  }

void addMessage() {
 if (messageeditingcontroller.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": username,
        "message": messageeditingcontroller.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      firestoreservices().addMessage(cid, chatMessageMap);

      setState(() {
        messageeditingcontroller.text = "";
      });
    }


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar:  AppBar(title: Text("Converstion Screen "),),
body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              
              alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Colors.grey,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageeditingcontroller,
                          
                         decoration: InputDecoration(
                              hintText: "Message ...",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              border: InputBorder.none
                          ),
                        )),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.black,
                                    Colors.blue
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/images/send.png",
                            height: 25, width: 25,)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
      
    
  }

  
}
class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({required this.message, required this.sendByMe});


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: sendByMe ? 0 : 24,
            right: sendByMe ? 24 : 0),
        alignment: sendByMe ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          margin: sendByMe
              ? EdgeInsets.only(left: 30)
              : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(
              top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: sendByMe ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23)
              ) :
              BorderRadius.only(
          topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23)),
              gradient: LinearGradient(
                colors: sendByMe ? [
                  const Color(0xff007EF4),
                  const Color(0xff2A75BC)
                ]
                    : [
                  Colors.black,
                  Colors.grey
                ],
              )
          ),
          child: Text(message,
              textAlign: TextAlign.start,
              style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              
              fontWeight: FontWeight.w300)),
        ),
      ),
    );
  }
}