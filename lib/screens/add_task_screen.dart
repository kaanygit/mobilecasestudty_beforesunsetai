import 'package:beforesunsetai_mobile_case_study/constant/colors.dart';
import 'package:beforesunsetai_mobile_case_study/constant/fonts.dart';
import 'package:beforesunsetai_mobile_case_study/widgets/buttons.dart';
import 'package:beforesunsetai_mobile_case_study/widgets/flask_message.dart';
import 'package:beforesunsetai_mobile_case_study/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Add Task',
          style: fontStyle(22, Colors.black, FontWeight.normal),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              MyTextField(
                borderColor: buttonColor,
                controller: _nameController,
                hintText: "Task Name",
                obscureText: false,
                keyboardType: TextInputType.multiline,
                enabled: true,
              ),
              SizedBox(height: 20),
              MyTextField(
                controller: _descriptionController,
                borderColor: buttonColor,
                maxLines: 10,
                hintText: "Description",
                obscureText: false,
                keyboardType: TextInputType.multiline,
                enabled: true,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _selectStartDate(context),
                  icon: Icon(Icons.calendar_today, color: Colors.black),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  label: Text(
                    'Select Start Date: ${_startDate.year}-${_startDate.month}-${_startDate.day}',
                    style: fontStyle(20, Colors.black, FontWeight.normal),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                  onPressed: () => _selectEndDate(context),
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  label: Text(
                    'Select End Date: ${_endDate.year}-${_endDate.month}-${_endDate.day}',
                    style: fontStyle(20, Colors.white, FontWeight.normal),
                  ),
                ),
              ),
              SizedBox(height: 50),
              MyButton(
                text: "Add Task",
                buttonColor: buttonColor,
                buttonTextColor: Colors.white,
                buttonTextSize: 20,
                buttonTextWeight: FontWeight.bold,
                onPressed: () {
                  final name = _nameController.text;
                  final description = _descriptionController.text;
                  if (name.isNotEmpty && description.isNotEmpty) {
                    context.read<TaskBloc>().add(AddTask(
                          name: name,
                          description: description,
                          startDate: _startDate,
                          endDate: _endDate,
                        ));
                    Navigator.of(context).pop();
                    showSuccessSnackBar(context, "Task added successfully");
                  } else {
                    showErrorSnackBar(context, "Please enter all fields");
                  }
                },
                borderRadius: BorderRadius.circular(16),
                buttonWidth: ButtonWidth.xxLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
