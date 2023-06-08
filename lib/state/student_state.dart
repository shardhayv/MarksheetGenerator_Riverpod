import '../model/student.dart';

class StudentState {
  bool isLoading;
  List<Student> students;

  StudentState({
    required this.isLoading,
    required this.students,
  });

  StudentState.initialState()
      : this(
          isLoading: false,
          students: [],
        );
  //CopyWith
  StudentState copyWith({
    bool? isLoading,
    List<Student>? students,
  }) {
    return StudentState(
      isLoading: isLoading ?? this.isLoading,
      students: students ?? this.students,
    );
  }
}
