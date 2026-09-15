import 'package:app_front/core/core.dart';
import 'package:app_front/features/tasks/domain/errors.dart';
import 'package:app_front/features/tasks/domain/task.dart';

class TasksService {
  final ApiClient _api = ApiClient();

  Future<WrResponse<StudentTaskListResponse>> getAvailableTasks({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _api.get(
      'task/available',
      converter: StudentTaskListResponse.converter,
      queryParameters: {'page': page, 'page_size': pageSize},
    );
    if (!response.isSuccess) throw TaskRequestException();
    return response;
  }

  Future<WrResponse<TaskAnswer>> submitAnswer(
    int taskId,
    TaskAnswerRequest data,
  ) async {
    final response = await _api.post(
      'task/$taskId/answer',
      converter: TaskAnswer.converter,
      data: data,
    );
    if (response.statusCode == 409) {
      throw TaskAlreadyAnsweredException();
    }
    if (response.statusCode == 400 || response.statusCode == 403) {
      throw TaskUnavailableException();
    }
    if (!response.isSuccess) throw TaskRequestException();
    return response;
  }

  Future<WrResponse<TaskHistoryResponse>> getHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _api.get(
      'task/history',
      converter: TaskHistoryResponse.converter,
      queryParameters: {'page': page, 'page_size': pageSize},
    );
    if (!response.isSuccess) throw TaskRequestException();
    return response;
  }
}
