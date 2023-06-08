import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marksheet_generator/model/student.dart';
import 'package:marksheet_generator/view_model/student_viewmodel.dart';

class AddMarkSheetView extends ConsumerStatefulWidget {
  const AddMarkSheetView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddMarkSheetViewState();
}

class _AddMarkSheetViewState extends ConsumerState<AddMarkSheetView> {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final marksController = TextEditingController();
  var gap = const SizedBox(
    height: 20,
  );
  static const List<String> list = <String>[
    'Flutter',
    'Web API',
    'Design Thinking',
    'IOT'
  ];

  String? selectedModule;
  double? result;
  String? division;

  double calculateTotalMarks(List<Student> students) {
    double totalMarks = 0;
    for (var student in students) {
      if (student.marks != null) {
        totalMarks += int.tryParse(student.marks!) ?? 0;
      }
    }
    return totalMarks;
  }

  String calculateResult(List<Student> students) {
    for (var student in students) {
      if (int.parse(student.marks!) < 40) {
        return 'Fail';
      }
    }
    return 'Pass';
  }

  String calculateDivision(List<Student> students, double totalMarks) {
    double percentage = (totalMarks / (students.length * 100)) * 100;

    if (percentage >= 60) {
      return '1st';
    } else if (percentage >= 50 && percentage < 60) {
      return '2nd';
    } else if (percentage >= 40 && percentage < 50) {
      return '3rd';
    } else {
      return 'Fail';
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(studentViewModelProvider);

    double totalMarks = calculateTotalMarks(data.students);

    String overallResult = calculateResult(data.students);

    String division = calculateDivision(data.students, totalMarks);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marksheet Generator'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: firstnameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                gap,
                TextFormField(
                  controller: lastnameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                gap,
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null) {
                      return 'Select module';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select module',
                    border: OutlineInputBorder(),
                  ),
                  items: list
                      .map(
                        (module) => DropdownMenuItem(
                          value: module,
                          child: Text(module),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedModule = value;
                    });
                  },
                ),
                gap,
                TextFormField(
                  controller: marksController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Marks',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                gap,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('Add'),
                    onPressed: () {
                      var firstName = firstnameController.text.trim();
                      var lastName = lastnameController.text.trim();
                      var marks = marksController.text.trim();

                      if (firstName.isEmpty ||
                          lastName.isEmpty ||
                          marks.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Please fill in all the required fields'),
                            duration: Duration(seconds: 1),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      var student = Student(
                        firstname: firstName,
                        lastname: lastName,
                        module: selectedModule,
                        marks: marks,
                      );

                      ref
                          .read(studentViewModelProvider.notifier)
                          .addStudent(student);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Student Marks Added Successfully'),
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
                ),
                gap,
                const Center(
                  child: Text(
                    'Marksheet',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                gap,
                Column(
                  children: [
                    data.students.isNotEmpty
                        ? SizedBox(
                            width: double.infinity,
                            child: SingleChildScrollView(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: DataTable(
                                  dataRowHeight:
                                      80, // Increase the height of each row

                                  headingRowColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          const Color.fromARGB(
                                              255, 176, 174, 174)),
                                  dataRowColor: MaterialStateColor.resolveWith(
                                      (states) => const Color.fromARGB(
                                          170, 197, 186, 186)),
                                  columns: const [
                                    DataColumn(
                                        label: Text(
                                      'First Name',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Last Name',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Module',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Marks',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Action',
                                      style: TextStyle(fontSize: 18),
                                    )),
                                  ],
                                  rows: data.students
                                      .map(
                                        (student) => DataRow(
                                          cells: [
                                            DataCell(Text(
                                              student.firstname ?? '',
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            )),
                                            DataCell(Text(
                                              student.lastname ?? '',
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            )),
                                            DataCell(Text(
                                              student.module ?? '',
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            )),
                                            DataCell(Text(
                                              student.marks ?? '',
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            )),
                                            DataCell(
                                              GestureDetector(
                                                  onTap: () {
                                                    ref
                                                        .read(
                                                            studentViewModelProvider
                                                                .notifier)
                                                        .delete(student);
                                                  },
                                                  child:
                                                      const Icon(Icons.delete)),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          )
                        : const Text('No data'),
                    data.students.isNotEmpty
                        ? SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Total Marks : $totalMarks'),
                                Text('Result : $overallResult'),
                                Text('Division : $division'),
                              ],
                            ),
                          )
                        : const Text('')
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
