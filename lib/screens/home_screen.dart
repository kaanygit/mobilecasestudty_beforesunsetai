import 'dart:io';
import 'package:beforesunsetai_mobile_case_study/constant/colors.dart';
import 'package:beforesunsetai_mobile_case_study/constant/fonts.dart';
import 'package:beforesunsetai_mobile_case_study/widgets/flask_message.dart';
import 'package:beforesunsetai_mobile_case_study/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import '../bloc/task_bloc.dart';
import 'add_task_screen.dart';
import 'task_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = '';
  String _userImage = '';
  final TextEditingController _newNameController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
    _newNameController.dispose();
  }

  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
      _userImage = prefs.getString('userImage') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor3,
        title: Row(
          children: [
            if (_userImage.isNotEmpty)
              CircleAvatar(
                backgroundImage: FileImage(File(_userImage)),
              ),
            if (_userImage.isEmpty)
              CircleAvatar(
                  backgroundImage: AssetImage("assets/images/avatar.jpg")),
            SizedBox(width: 10),
            Text(
              _username.length > 20
                  ? 'Hello, ${_username.substring(0, 20)}...'
                  : "Hello, $_username",
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor3,
      body: Column(
        children: [
          Expanded(
            child: EasyDateTimeLine(
              dayProps: const EasyDayProps(
                todayHighlightStyle: TodayHighlightStyle.withBackground,
                // todayHighlightColor: Colors.grey,
              ),
              initialDate: DateTime.now(),
              onDateChange: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoaded) {
                  final selectedDateTasks = state.tasks.where((task) {
                    return task.startDate
                            .isBefore(_selectedDate.add(Duration(days: 1))) &&
                        task.endDate
                            .isAfter(_selectedDate.subtract(Duration(days: 1)));
                  }).toList();

                  if (selectedDateTasks.isEmpty) {
                    return Center(
                        child: Text(
                      'You do not have task',
                      style: fontStyle(18, Colors.black, FontWeight.normal),
                    ));
                  }
                  print(selectedDateTasks);
                  final completedTasks = selectedDateTasks
                      .where((task) => task.isCompleted)
                      .toList();
                  final incompleteTasks = selectedDateTasks
                      .where((task) => !task.isCompleted)
                      .toList();
                  print("complete  : $completedTasks");
                  print("complete not  : $incompleteTasks");
                  return ListView(
                    children: [
                      if (incompleteTasks.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Tasks',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ...incompleteTasks.map((task) {
                        return Dismissible(
                          key: Key(task.id),
                          direction: DismissDirection.horizontal,
                          background: Container(
                            color: Colors.green,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.check, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              return await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Complete Task?'),
                                  content: Text(
                                      'Are you sure you want to mark this task as completed?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<TaskBloc>()
                                            .add(ToggleTask(task.id));
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text('Complete'),
                                    ),
                                  ],
                                ),
                              );
                            } else if (direction ==
                                DismissDirection.endToStart) {
                              return await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete Task?'),
                                  content: Text(
                                      'Are you sure you want to delete this task?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<TaskBloc>()
                                            .add(DeleteTask(task.id));
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return false;
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TaskDetailsScreen(task: task),
                                ),
                              );
                            },
                            child: Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: buttonColor),
                                  borderRadius: BorderRadius.circular(10),
                                  color: task.isCompleted
                                      ? Colors.greenAccent
                                      : Colors.white,
                                ),
                                margin: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            task.name,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: task.isCompleted
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            task.description,
                                            style: TextStyle(
                                              color: task.isCompleted
                                                  ? Colors.white
                                                  : Colors.grey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (task.isCompleted)
                                      Text(
                                        'Completed',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      if (completedTasks.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Completed Tasks',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ...completedTasks.map((task) {
                        return Dismissible(
                          key: Key(task.id),
                          direction: DismissDirection
                              .endToStart, // Sadece sağdan sola kaydırma
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              return await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete Task?'),
                                  content: Text(
                                      'Are you sure you want to delete this task?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<TaskBloc>()
                                            .add(DeleteTask(task.id));
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return false;
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TaskDetailsScreen(task: task),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                                color: task.isCompleted
                                    ? Colors.greenAccent
                                    : Colors.white,
                              ),
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: task.isCompleted
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          task.description,
                                          style: TextStyle(
                                            color: task.isCompleted
                                                ? Colors.white
                                                : Colors.grey,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (task.isCompleted)
                                    Text(
                                      'Completed',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                } else if (state is TaskLoading) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Center(child: Text('Göreviniz bulunmamaktadır'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: Container(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: backgroundColor3,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            DrawerHeader(
              child: Text(
                _username.length > 20
                    ? 'Hello, ${_username.substring(0, 20)}...'
                    : "Hello, $_username",
                style: fontStyle(25, Colors.black, FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(CupertinoIcons.book, color: Colors.amber),
              title: Text(
                "Terms of Use",
                style: fontStyle(15, Colors.black, FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/terms_of_use');
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.shield, color: Colors.blue),
              title: Text(
                "Privacy Policy",
                style: fontStyle(15, Colors.black, FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/privacy_policy');
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.upload_circle, color: Colors.green),
              title: Text(
                "Update User Data",
                style: fontStyle(15, Colors.black, FontWeight.bold),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: backgroundColor3,
                      title: Text(
                        "Update User Data?",
                        style: fontStyle(20, Colors.black, FontWeight.bold),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : AssetImage("assets/images/avatar.jpg")
                                    as ImageProvider,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: _pickImage,
                            child: Text(
                              'Tap to select an image',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MyTextField(
                            controller: _newNameController,
                            hintText: "New name",
                            obscureText: false,
                            keyboardType: TextInputType.multiline,
                            enabled: true,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.black,
                          ),
                          child: Text(
                            "Cancel",
                            style:
                                fontStyle(17, Colors.white, FontWeight.normal),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            await _updateUserData();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Update Data",
                            style:
                                fontStyle(17, Colors.white, FontWeight.normal),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.trash, color: Colors.red),
              title: Text(
                "Delete User Data",
                style: fontStyle(15, Colors.black, FontWeight.bold),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: backgroundColor3,
                      title: Text(
                        "Delete User Data?",
                        style: fontStyle(20, Colors.black, FontWeight.bold),
                      ),
                      content: Text(
                        "Are you sure you want to delete user data?",
                        textAlign: TextAlign.center,
                        style: fontStyle(17, Colors.black, FontWeight.normal),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.black,
                          ),
                          child: Text(
                            "Cancel",
                            style:
                                fontStyle(17, Colors.white, FontWeight.normal),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            await _deleteUserData();
                            await Navigator.of(context)
                                .pushReplacementNamed('/');
                          },
                          child: Text(
                            "Delete",
                            style:
                                fontStyle(17, Colors.white, FontWeight.normal),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _username = '';
    });
    showSuccessSnackBar(context, "All data were successfully deleted.");
  }

  Future<void> _updateUserData() async {
    final prefs = await SharedPreferences.getInstance();

    if (_newNameController.text.isNotEmpty) {
      await prefs.setString('username', _newNameController.text);
    }

    if (_image != null) {
      await prefs.setString('userImage', _image!.path);
    }

    await _loadUserInfo();
    await _newNameController.clear;
    showSuccessSnackBar(context, "All data have been successfully updated.");
  }
}
