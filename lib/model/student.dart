class Student {
  final String? firstname;
  final String? lastname;
  final String? module;
  final String? marks;

  Student({this.firstname, this.lastname, this.module, this.marks});

  @override
  String toString() {
    return '$firstname, $lastname, $module, $marks)';
  }
}
