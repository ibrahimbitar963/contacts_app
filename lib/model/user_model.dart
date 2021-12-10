
import 'package:contacts_app/helper/constance.dart';

class UserModel{
  UserModel({this.email,this.name,this.phone,this.id});
int id;
String name, phone,email;
toJson(){
  return {
    columnName:name,
    columnEmail:email,
    columnPhone:phone,
    columnId:id,
  };

}
UserModel.fromJson(Map <String ,dynamic>map){
  id = map[columnId];
  name = map[columnName];
  phone=map[columnPhone];
  email=map[columnEmail];

}
}