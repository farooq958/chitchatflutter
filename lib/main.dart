import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfirebasesetup/Services/firestoreservices.dart';
import 'package:flutterfirebasesetup/Services/helper.dart';
import 'package:flutterfirebasesetup/Views/List_of_user.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 TextEditingController emailcontroller = TextEditingController();

  firestoreservices firestorservicess = new firestoreservices();
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  title: Text('ChitChat Login'),
  backgroundColor: Colors.deepPurple,
),
body:  Column(
crossAxisAlignment: CrossAxisAlignment.start,

children: [

Center(
  child:   Padding(
  
    padding: const EdgeInsets.only(top : 50),
  
    child:   Text('Login With Email',style: TextStyle(fontSize: 40),),
  
  ),
),
Padding(
  padding: const EdgeInsets.only( top : 50.0),
  child:   Container(child: TextFormField(
    controller: emailcontroller,
    decoration: InputDecoration(
      hintText: 'Enter your Email',
    ),
    
  )),
),
Padding(
  padding: const EdgeInsets.all(8.0),
  child:   GestureDetector (
    onTap: () async {
      Map<String,String> userDataMap = {
                "userEmail" : emailcontroller.text
              };
         var checkk = await firestorservicess.getuserinfoall(emailcontroller.text);
             print(checkk);
              
              if(checkk == false)
              {
                firestorservicess.addUserinfo(userDataMap); 
                HelperFunctions.saveUserEmailSharedPreference(emailcontroller.text);
                 Navigator.push(context, MaterialPageRoute(builder:(context) => Userlistpage(username: emailcontroller.text,)));
              
              }
              else
              {
                HelperFunctions.saveUserEmailSharedPreference(emailcontroller.text);
                Navigator.push(context, MaterialPageRoute(builder:(context) => Userlistpage(username: emailcontroller.text,)));
              }
              
    
  
   // print('done');
   
  //emailcontroller.text=" ";

    },
    child: Container(
    
                                height: 50,
    
                                decoration: BoxDecoration(
    
                                  color: Color(0xff1aa260),
    
                                  borderRadius:BorderRadius.circular(10)
    
                                ),
    
                                child: const Center(
    
                                  child: Text('SignIn'),
    
                                ),
    
                              ),
  ),
)



/*Padding(
  padding: const EdgeInsets.only(top: 10),
  child:   Container(child: Text('List Of Users To chat' ,style: TextStyle(fontSize: 40),),decoration: BoxDecoration( border: Border.all(width: 5, color: Colors.red),borderRadius: BorderRadius.circular(30)),),
) ,*/



],



),

    );
  
  
  }



}
