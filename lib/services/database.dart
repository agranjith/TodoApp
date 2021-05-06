import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/model/todo.dart';

class DatabaseService{
  String uid;
 DatabaseService({this.uid});
  // CollectionReference todosCollection= FirebaseFirestore.instance.collection("users");
  // CollectionReference todosCollection= FirebaseFirestore.instance.collection("users").doc(uid).collection("Todo");

  Future createNewTodo(String title) async{
    CollectionReference todosCollection= FirebaseFirestore.instance.collection("users").doc(uid).collection("Todo");
    return await todosCollection.add({
      "title": title,
      "isCompleted": false,
    });
  }

  Future completeTask(uId)async{
    CollectionReference todosCollection= FirebaseFirestore.instance.collection("users").doc(uid).collection("Todo");
    await todosCollection.doc(uId).update({
      "isCompleted":true
    });
  }

  Future incompleteTask(uId)async{
    CollectionReference todosCollection= FirebaseFirestore.instance.collection("users").doc(uid).collection("Todo");
    await todosCollection.doc(uId).update({
      "isCompleted":false
    });
  }

  Future removeTodo(uId) async{
    CollectionReference todosCollection= FirebaseFirestore.instance.collection("users").doc(uid).collection("Todo");
    await todosCollection.doc(uId).delete();
  }
  List<Todo> todoFromFirestore(QuerySnapshot snapshot){
    if(snapshot!=null){
      return snapshot.docs.map((e){
        return Todo(
          isCompleted: e.data()["isCompleted"],
          title: e.data()["title"],
          uid: e.id,
        );
      }).toList();
    }else{
      return null;
    }
  }

  Stream<List<Todo>> listTodos(){
    CollectionReference todosCollection= FirebaseFirestore.instance.collection("users").doc(uid).collection("Todo");
    return todosCollection.snapshots().map(todoFromFirestore);
  }
}
