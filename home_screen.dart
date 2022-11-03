
import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/repository/db_repository.dart';
import 'package:todo_app/screens/home_screen/todo_delegate.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {

  List<TodoModel> todoModels = [];

  GlobalKey<FormState> myFormKey = GlobalKey<FormState>();


  getData() async {
    DbRepo dbRepo = DbRepo();
    await dbRepo.openDb();
    List<Map<String, dynamic>> mapsList = await dbRepo.retrieveDb('todos');

    setState(() {
      todoModels = mapsList.map((e) => TodoModel(todoText: e['todoText'], isDone: e['isDone'] == 1 ?true :false, id: e['id'])).toList();
    });
  }


  @override
  void initState() {
    super.initState();
    getData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white70,

      appBar: AppBar(
        title: const Text("Let's do your tasks together"),
        backgroundColor: const Color(0xFF0C0026),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: todoModels.map((e) => Tododelegate(todoModel: e,)).toList(),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.large(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
          onPressed: (){

            String? newTodoText;

            showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Form(
                      key: myFormKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.all(10),

                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(40)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 3,
                                    blurRadius: 3,
                                  )
                                ]
                              ),
                              child: TextFormField(

                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                ),
                                validator: (text){
                                  if(text!.isEmpty){
                                    return "This field can not be empty!";
                                  }
                                  return null;
                                },
                                onSaved: (text){
                                  newTodoText = text!;
                                },
                              ),

                            ),
                            TextButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                              ),
                                onPressed: () async{
                                  if(myFormKey.currentState!.validate()){
                                    myFormKey.currentState!.save();

                                    DbRepo dbRepo = DbRepo();
                                    await dbRepo.openDb();
                                    Map<String, dynamic> newTodoData = {
                                      'todoText' : newTodoText,
                                      'isDone' : 0
                                    };
                                    await dbRepo.insertDb(newTodoData, 'todos');

                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);

                                    getData();
                                  }
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.all(Radius.circular(40)),
                                  ),
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("Submit"),
                                    ],
                                  ),
                                )
                            )
                          ],
                        )
                    ),
                  ),
                ),
            );
          },
      child: const Icon(Icons.add),
      ),
    );
  }
}
