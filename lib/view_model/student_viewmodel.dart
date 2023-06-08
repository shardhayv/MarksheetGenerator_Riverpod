import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marksheet_generator/model/student.dart';
import 'package:marksheet_generator/state/student_state.dart';

//provider
final studentViewModelProvider =
    StateNotifierProvider<StudentViewModel, StudentState>(
  (ref) => StudentViewModel(),
);

class StudentViewModel extends StateNotifier<StudentState> {
  StudentViewModel() : super(StudentState.initialState());

//Add Student
  void addStudent(Student student) {
    state = state.copyWith(isLoading: true);
//putting data in server
    state.students.add(student);
    state = state.copyWith(isLoading: false);
  }

  //Delete Student

  void delete(Student student) {
    state = state.copyWith(isLoading: true);
    state.students.remove(student);
    state = state.copyWith(isLoading: false);
  }
}
