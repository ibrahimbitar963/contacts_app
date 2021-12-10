import 'package:contacts_app/helper/database_helper.dart';
import 'package:contacts_app/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String name, phone, email;
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  List<UserModel> userslist = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Contacts'),
      ),
      body: getAllUser(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => openAlertBox(),
      backgroundColor: Colors.red,
      child: Icon(Icons.add),
    );
  }

  getAllUser() {
    return FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) {
          return createListView(context, snapshot);
        });
  }

  Future<List<UserModel>> _getData() async {
    var dbHelper = DataBaseHelper.db;
    await dbHelper.getAllUsers().then((value) {
      print(value);
      userslist = value;
    });
    return userslist;
  }

  createListView(BuildContext context, AsyncSnapshot snapshot) {
    userslist = snapshot.data;
    if (userslist != null) {
      return ListView.builder(
          itemCount: userslist.length,
          itemBuilder: (context, index) {
            return _buildItem(userslist[index], index);
          });
    } else {
      return Container();
    }
  }

  openAlertBox() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              width: 200,
              height: 200,
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    TextFormField(
                        initialValue: name,
                        decoration: InputDecoration(
                          hintText: 'add name',
                          fillColor: Colors.grey,
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          return null;
                        },
                        onSaved: (String value) {
                          name = value;
                        }),
                    TextFormField(
                        initialValue: phone,
                        decoration: InputDecoration(
                          hintText: 'add phone',
                          fillColor: Colors.grey,
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          return null;
                        },
                        onSaved: (String value) {
                          phone = value;
                        }),
                    TextFormField(
                        initialValue: email,
                        decoration: InputDecoration(
                          hintText: 'add email',
                          fillColor: Colors.grey,
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          return null;
                        },
                        onSaved: (String value) {
                          email = value;
                        }),
                    FlatButton(
                        onPressed: () {
                          addUser();
                        },
                        child: Text('Add User')),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void addUser() {
    _key.currentState.save();
    var dbHelper = DataBaseHelper.db;
    dbHelper
        .insertUser(UserModel(
          phone: phone,
          name: name,
          email: email,
        ))
        .then((value) => Navigator.pop(context));
    setState(() {});
  }

  _buildItem(UserModel model, int index) {
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Column(
              children: [
                Container(
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    child: Text(
                      model.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min ,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_circle),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Text(
                      model.name,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Icon(Icons.phone),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Text(
                      model.phone,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Icon(Icons.mail),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Text(
                      model.email,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ],
                ),

              ],
            ),
          ],
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(top:20.0),
          child: IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){},
          ),
        )
      ),
    );
  }
}
///////////
