import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/loading.dart';
import 'package:todo/login.dart';
import 'package:todo/services/database.dart';

import 'model/todo.dart';

class TodoList extends StatefulWidget {
  String uid;
  TodoList({this.uid});
  @override
  _TodoListState createState() => _TodoListState(uid: uid);
}

class _TodoListState extends State<TodoList> {
  bool isCompleted =true;
  String uid;
  TextEditingController todoTitle=TextEditingController();
  _TodoListState({this.uid});
  FirebaseAuth auth=FirebaseAuth.instance;
  Future<void> logout() async {

    User user= await auth.signOut() as User;

  }

  Future<bool> backPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        contentPadding: EdgeInsets.all(20),
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text("YES" ,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(
          title: Text('Todos',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
          toolbarHeight: 70,
          actions: [
            IconButton(icon: Icon(Icons.power_settings_new), onPressed: (){
              logout();
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> LoginPage()));

            })
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: StreamBuilder<List<Todo>>(
              stream: DatabaseService(uid: uid).listTodos(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return Loading();
                }
                List<Todo> todos=snapshot.data;
                return Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      ListView.separated(
                          separatorBuilder: (context,index)=>Divider(),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: todos.length,
                          itemBuilder: (context,index){
                        return Dismissible(
                          key: Key(todos[index].title.toString()),
                          background: Container(
                            padding: EdgeInsets.only(left: 20),
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.delete),
                            color: Colors.red,
                          ),
                          onDismissed: (direction) async => await DatabaseService(uid: uid).removeTodo(todos[index].uid),
                          child: ListTile(
                            onTap: (){
                              setState(() {
                                bool iscom=todos[index].isCompleted;
                                if(iscom==false) {
                                  DatabaseService(uid: uid).completeTask(todos[index].uid);
                                }else{
                                  DatabaseService(uid: uid).incompleteTask(todos[index].uid);
                                }
                              });
                            },
                            leading: Container(
                              padding: EdgeInsets.all(2),
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: todos[index].isCompleted ?Icon(
                                  Icons.check,
                                  color: Colors.white,
                              )
                                  : Container(),
                            ),
                            title: Text(
                              todos[index].title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                );
              }
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context)=>SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 25,vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                title: Row(
                  children: [
                    Text("Add TODO",style: TextStyle(fontSize: 18),),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                          Icons.cancel,
                          color: Colors.redAccent,
                          size: 30,
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                children: [
                  Divider(),
                  TextFormField(
                    controller: todoTitle,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.5,
                    ),
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "eg. running"
                    ),
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text("ADD"),
                      color: Theme.of(context).primaryColor,
                      onPressed: () async{
                        if(todoTitle.text.isNotEmpty){
                          await DatabaseService(uid: uid).createNewTodo(todoTitle.text.trim());
                          todoTitle.clear();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  )
                ],
              )
            );
          },
        ),

    );
  }
}
