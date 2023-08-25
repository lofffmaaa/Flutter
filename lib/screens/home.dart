// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:flutterapp/constants/colors.dart';
import 'package:flutterapp/widgets/todo_item.dart';
import 'package:flutterapp/model/todo.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    _foundToDo = todosList;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  searchBox(),
                  Expanded(
                      child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 50,
                          bottom: 20,
                        ),
                        child: Text(
                          'Хийх зүйлсийн жагсаалт',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                      ),
                      for (ToDo todo in _foundToDo.reversed)
                        ToDoItem(
                          todo: todo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDiItem,
                        ),
                    ],
                  ))
                ],
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0),
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                        hintText: 'Хийх зүйлсээ нэмнэ үү!',
                        border: InputBorder.none)),
              )),
              Container(
                margin: EdgeInsets.only(bottom: 20, right: 20),
                child: ElevatedButton(
                  child: Text(
                    '+',
                    style: TextStyle(fontSize: 40),
                  ),
                  onPressed: () {
                    _todoController.text == ''
                        ? null
                        : _addToDoItem(_todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: tdBlue,
                      minimumSize: Size(
                        60,
                        60,
                      ),
                      elevation: 10),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDiItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String toDo) {
    setState(() {
      todosList.add(ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: toDo,
      ));
      _todoController.clear();
    });
  }

  void _runFilter(String enteredKeyWord) {
    List<ToDo> results = [];
    if (enteredKeyWord.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyWord.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: tdBlack,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
            border: InputBorder.none,
            hintText: 'Хайх',
            hintStyle: TextStyle(color: tdGrey)),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor, //safearea
      elevation: 0, //safearea shadow off
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu, color: tdBlack, size: 30),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/avatar.jpeg'),
            ),
          )
        ],
      ),
    );
  }
}
