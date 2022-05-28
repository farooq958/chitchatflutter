import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebasesetup/Services/firestoreservices.dart';
import 'package:flutterfirebasesetup/Views/Chat.dart';


class Userlistpage extends StatefulWidget {
  final String username;
  const Userlistpage ({ Key? key ,required this.username}) : super(key: key);

  @override
  State<Userlistpage> createState() => Userlistpagestate(this.username);
}

// ignore: camel_case_types
class Userlistpagestate extends State<Userlistpage> {
   
   
   getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
 
  String username;
  Userlistpagestate(this.username);
firestoreservices firestorservice = firestoreservices();
 
  @override
  Widget build(BuildContext context) {
    print(username);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("User List"),
        
      ),
      body: Column(
      
     children: [
        Text("Welcome " + username.substring(0,username.indexOf('@')), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.deepOrange),),
      
        StreamBuilder(
          
          stream:  firestorservice.getuserinfo(username),
          
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        
        if(snapshot.hasData)
        {
          print(username);
        
        return Expanded(
          child: ListView.builder(itemCount: snapshot.data!.docs.length ,
          itemBuilder: (context,index){
          
          final DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];
        
          return GestureDetector(child: Card(
            child: ListTile( 
              title: Text( documentSnapshot['userEmail']  )))
          
          ,
          onTap: () {
            print(documentSnapshot['userEmail']);
            var useremail= documentSnapshot['userEmail'];
            String chatroomid= getChatRoomId(useremail.substring(0,useremail.indexOf('@')),username.substring(0,username.indexOf('@')));
            List<String> users = [useremail,username];
            Map<String,dynamic> chatroommap={
"user":users,
"chatroomid": chatroomid
            };
            firestorservice.addChatRoom(chatroommap, chatroomid);
         Navigator.push(context, MaterialPageRoute(builder:(context) =>chat(cid: chatroomid, username: username)));
          },
          
          );
          
          
          
          }
        

          ),
        );
        
        
         }
        else
        {
        return Container();
        }
        
          },
        
        
        )
     ],
    
      
      )
    );
    
  }
}