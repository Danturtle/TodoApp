
import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/repository/db_repository.dart';

class Tododelegate extends StatefulWidget {
  const Tododelegate({Key? key, required this.todoModel}) : super(key: key);

  final TodoModel todoModel;

  @override
  State<Tododelegate> createState() => _TododelegateState();
}

class _TododelegateState extends State<Tododelegate> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(widget.todoModel.isDone? const Color(0xFF0C0026) :Colors.black),
        backgroundColor: MaterialStateProperty.all(widget.todoModel.isDone? Colors.amber :Colors.white),
      ),
        onLongPress: () async{
          DbRepo dbRepo = DbRepo();
          await dbRepo.openDb();
          await dbRepo.deleteDb('todos', widget.todoModel.id!);
        },
        onPressed: () async{
          DbRepo dbRepo = DbRepo();
          await dbRepo.openDb();
          await dbRepo.updateDb(
              'todos',
              {
                "todoText" : widget.todoModel.todoText,
                "isDone" : widget.todoModel.isDone ?0 :1
              },
              widget.todoModel.id!
          );
          setState(() {
            widget.todoModel.isDone = !widget.todoModel.isDone;
          });
        },
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                spreadRadius: 8,
              )
            ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.todoModel.todoText),
              Icon(widget.todoModel.isDone ?Icons.check_box_outlined :Icons.check_box_outline_blank)
            ],
          ),
        )
    );
  }
}
