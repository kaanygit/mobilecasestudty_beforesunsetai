import 'package:beforesunsetai_mobile_case_study/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/task_bloc.dart';
import '../model/task.dart';
import '../widgets/buttons.dart';
import '../widgets/text_field.dart';
import '../constant/fonts.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  TaskDetailsScreen({required this.task});

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late DateTime _startDate;
  late DateTime _endDate;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.name);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _startDate = widget.task.startDate;
    _endDate = widget.task.endDate;
    _isCompleted = widget.task.isCompleted;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _updateTask() {
    final updatedTask = Task(
      id: widget.task.id,
      name: _nameController.text,
      description: _descriptionController.text,
      startDate: _startDate,
      endDate: _endDate,
      isCompleted: _isCompleted,
    );

    BlocProvider.of<TaskBloc>(context).add(UpdateTask(updatedTask));
    setState(() {
      isEditing = false;
    });
  }

  void _deleteTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                style: fontStyle(17, Colors.white, FontWeight.normal),
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
                BlocProvider.of<TaskBloc>(context)
                    .add(DeleteTask(widget.task.id));
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                "Delete",
                style: fontStyle(17, Colors.white, FontWeight.normal),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate = isStartDate ? _startDate : _endDate;
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2101);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor3,
        title: Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _updateTask();
              } else {
                _toggleEditing();
              }
            },
          ),
        ],
      ),
      backgroundColor: backgroundColor3,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isEditing
                  ? MyTextField(
                      controller: _nameController,
                      hintText: 'Name',
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      enabled: true,
                    )
                  : Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name:',
                            style: fontStyle(18, Colors.black, FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.task.name,
                            style:
                                fontStyle(18, Colors.black, FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
              SizedBox(height: 15),
              isEditing
                  ? MyTextField(
                      controller: _descriptionController,
                      hintText: 'Description',
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      enabled: true,
                      maxLines: 5,
                    )
                  : Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description:',
                            style: fontStyle(18, Colors.black, FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.task.description,
                            style:
                                fontStyle(18, Colors.black, FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
              SizedBox(height: 15),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Colors.purple, size: 25),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date:',
                              style:
                                  fontStyle(18, Colors.black, FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              formatter.format(_startDate),
                              style:
                                  fontStyle(18, Colors.grey, FontWeight.normal),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isEditing)
                    TextButton(
                      onPressed: () => _selectDate(context, true),
                      child: Text('Select Start Date'),
                    ),
                ],
              ),
              SizedBox(height: 15),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Colors.purple, size: 25),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End Date:',
                              style:
                                  fontStyle(18, Colors.black, FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              formatter.format(_endDate),
                              style:
                                  fontStyle(18, Colors.grey, FontWeight.normal),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isEditing)
                    TextButton(
                      onPressed: () => _selectDate(context, false),
                      child: Text('Select End Date'),
                    ),
                ],
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text(
                      'Completed: ',
                      style: fontStyle(18, Colors.black, FontWeight.bold),
                    ),
                    if (isEditing)
                      Switch(
                        value: _isCompleted,
                        onChanged: (value) {
                          setState(() {
                            _isCompleted = value;
                          });
                        },
                      ),
                    if (!isEditing)
                      Text(
                        _isCompleted ? 'Yes' : 'No',
                        style: fontStyle(18, Colors.black, FontWeight.normal),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.center,
                child: MyButton(
                  text: "Delete Task",
                  buttonColor: buttonColor2,
                  buttonTextColor: Colors.white,
                  buttonTextSize: 20,
                  buttonTextWeight: FontWeight.bold,
                  onPressed: _deleteTask,
                  borderRadius: BorderRadius.circular(16),
                  buttonWidth: ButtonWidth.xLarge,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
