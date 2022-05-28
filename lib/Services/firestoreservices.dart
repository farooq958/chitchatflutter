

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: camel_case_types
class firestoreservices {
  
  
   Future<void> addUserinfo( userdata) async {
    FirebaseFirestore.instance.collection("users").add(userdata).catchError((e) {
      print(e.toString());
    });
  }

 getuserinfo(String email)  {
   final CollectionReference p = FirebaseFirestore.instance
        .collection("users");
    return p.where("userEmail", isNotEqualTo: email ).get().asStream();
   
   
    }
  Future<bool>   getuserinfoall (String email)  async {
   final CollectionReference p =  FirebaseFirestore.instance
        .collection("users");
 // ignore: await_only_futures
 var val = await p.where("userEmail",isEqualTo: email).get();
   //int count = val.length;
   //int nll=  int.parse(val.length.toString());
   //print(nll);
  
print(val.size);
  
  
   // ignore: unrelated_type_equality_checks
   if(val.size == 0)
   {
     return false;

   }
   else
   {
   return true;
   }
   }
    
    
    

 Future<void> addChatRoom(chatRoom, chatRoomId) async {
   //chatroom is a map[string ,array or dynamic]
  await  FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }


Future<void> addMessage(String chatRoomId, chatMessageData){

 return   FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
          print(e.toString());
    });
  }


getChats(String chatRoomId) async{
    return  FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time').snapshots();
       
  }

  }


 