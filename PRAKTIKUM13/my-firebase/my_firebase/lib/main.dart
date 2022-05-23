import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_firebase/model/user.dart';
import 'package:my_firebase/page/user_page.dart';

Future main() async{
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Setup Myirebase';
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All User',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title:'Setup Myfirebase'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({ Key? key, required this.title }) : super(key: key);

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

  @override
class _MyHomePageState extends State<MyHomePage> {
  final controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('All Users'),
    ),
    // body: Center(
    //   child: Column(
    //     children: [
    //       ElevatedButton(
    //         onPressed: () {
    //           final docUser = 
    //             FirebaseFirestore.instance.collection("users").doc("my-id");
                
    //           docUser.update({"name": "April"});
    //         },
    //         child: Text("Update"),
    //       ),
    //       const SizedBox(
    //         height: 32,
    //       ),
    //       ElevatedButton(
    //         onPressed: () {
    //           final docUser = 
    //             FirebaseFirestore.instance.collection("users").doc("my-id");
                
    //           docUser.delete();
    //         },
    //         child: Text("Delete"),
    //       )
    //     ],
    //   ),
    // ),
    body: StreamBuilder<List<User>>(
      stream: readUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error'),
              );
            } else if (snapshot.hasData) {
              final users = snapshot.data!;
          return ListView(
            children: users.map(buildUser).toList(),
          );
        }else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ),
    floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => UserPage()));
            }),
      );
  
    
    Widget buildUser(User user) => ListTile(
      leading: CircleAvatar(child: Text('${user.age}')),
      title: Text(user.name),
      subtitle: Text(user.birthday.toIso8601String()),
    );
  
  Stream<List<User>> readUsers() => FirebaseFirestore.instance
  .collection('users')
  .snapshots()
  .map((snapshot)=>
      snapshot.docs.map((doc) => User.fromJson(doc.data())).toList()
  );
  
  Future CreateUser({required String name }) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    
    final user = User(
    id: docUser.id,
    name: name,
    age: 21,
    birthday: DateTime(2002, 4, 6),
    );
    final json = user.toJson();
    
    await docUser.set(json);
  }
}
