import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_firebase/model/user.dart';
import 'package:intl/intl.dart';

class UserPage extends StatefulWidget {
  const UserPage({ Key? key }) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerDate = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: ListView(
      padding: EdgeInsets.all(16),
      children: <Widget>[
        TextField(
          controller: controllerName,
          decoration: decoration('Name'),
        ),
        const SizedBox(height: 24),
        TextField(
        controller: controllerAge,
          decoration: decoration('Age'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        DateTimeField(
          controller: controllerDate,
          decoration: decoration('Birthday'),
          format: DateFormat('yyyy-MM-dd'),
          onShowPicker: (context, currentValue) =>showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            initialDate: currentValue ?? DateTime.now()
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          child: Text('Create'),
          onPressed: () {
            final user = User(
              name: controllerName.text,
              age: int.parse(controllerAge.text),
              birthday: DateTime.parse(controllerDate.text)
            );
            
            createUser(user);
            
            Navigator.pop(context);
          },
          ),
      ]
    ),
  );
}
  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );
  
  Future createUser(User user) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;
    
    final json = user.toJson();
    await docUser.set(json);
  }
}
