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
  bool flag = false;
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
      onPressed: () => openAlertBox(null),
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
            return Dismissible(
              background: Container(
                color: Colors.red,
              ),
                key: UniqueKey(),
                onDismissed:(direction){
          DataBaseHelper.db.deleteUser(userslist[index].id);

                } ,
                child: _buildItem(userslist[index], index));
          });
    } else {
      return Container();
    }
  }

  openAlertBox(UserModel model) {
    if (model != null) {
      name = model.name;
      phone = model.phone;
      email = model.email;
      flag = true;
    } else {
      name = '';
      phone = '';
      email = '';
      flag = false;
    }
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
                          flag ? editUser(model.id) : addUser();
                        },
                        child: Text(flag ? 'Edit User' : 'add user')),
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

  void editUser(int id) {
    _key.currentState.save();
    var dbHelper = DataBaseHelper.db;
    UserModel user = UserModel(id: id, email: email, phone: phone, name: name);
    dbHelper.updateUser(user).then((value) => Navigator.pop(context));
    setState(() {
      flag = false;
    });
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
                mainAxisSize: MainAxisSize.min,
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
                  SizedBox(
                    height: 20,
                  ),
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
                  SizedBox(
                    height: 20,
                  ),
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
            padding: const EdgeInsets.only(top: 20.0),
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => onEdit(model, index),
            ),
          )),
    );
  }

  onEdit(UserModel model, int index) {
    openAlertBox(model);
  }
}

