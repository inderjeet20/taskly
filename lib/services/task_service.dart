import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskly/models/task_model.dart';
import 'package:taskly/utils/app_constants.dart';

class TaskService {
  TaskService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _taskCollection(String uid) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection(AppConstants.tasksCollection);
  }

  Stream<List<TaskModel>> streamTasks(String uid) {
    return _taskCollection(uid).orderBy('date').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<TaskModel> createTask(String uid, TaskModel task) async {
    final doc = _taskCollection(uid).doc();
    final createdTask = task.copyWith(id: doc.id, userId: uid);
    await doc.set(createdTask.toMap());
    return createdTask;
  }

  Future<void> updateTask(String uid, TaskModel task) async {
    await _taskCollection(uid).doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String uid, String taskId) async {
    await _taskCollection(uid).doc(taskId).delete();
  }
}
