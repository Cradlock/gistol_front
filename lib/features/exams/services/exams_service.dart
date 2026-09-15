import 'package:app_front/core/core.dart';
import 'package:app_front/features/exams/domain/errors.dart';
import 'package:app_front/features/exams/domain/exam.dart';

class ExamsService {
  final ApiClient _api = ApiClient();

  Future<WrResponse<ExamListResponse>> getAvailable({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _api.get(
      'exams/available',
      converter: ExamListResponse.converter,
      queryParameters: {'page': page, 'page_size': pageSize},
    );
    if (!response.isSuccess) throw ExamRequestException();
    return response;
  }

  Future<WrResponse<SessionStart>> startExam(int examId) async {
    final response = await _api.post(
      'exams/$examId/start',
      converter: SessionStart.converter,
    );
    if (response.statusCode == 409) throw ExamAlreadySubmittedException();
    if (response.statusCode == 400 || response.statusCode == 403) {
      throw ExamUnavailableException();
    }
    if (!response.isSuccess) throw ExamRequestException();
    return response;
  }

  Future<WrResponse<SessionTake>> takeSession(int sessionId) async {
    final response = await _api.get(
      'exams/sessions/$sessionId/take',
      converter: SessionTake.converter,
    );
    if (response.statusCode == 409) throw ExamAlreadySubmittedException();
    if (response.statusCode == 400 || response.statusCode == 403) {
      throw ExamUnavailableException();
    }
    if (!response.isSuccess) throw ExamRequestException();
    return response;
  }

  Future<WrResponse<StudentSavedAnswer>> saveAnswer(
    int sessionId,
    int questionId,
    AnswerUpsertRequest data,
  ) async {
    final response = await _api.put(
      'exams/sessions/$sessionId/answers/$questionId',
      converter: StudentSavedAnswer.converter,
      data: data,
    );
    if (response.statusCode == 409) throw ExamAlreadySubmittedException();
    if (response.statusCode == 400 || response.statusCode == 403) {
      throw ExamUnavailableException();
    }
    if (!response.isSuccess) throw ExamRequestException();
    return response;
  }

  Future<WrResponse<SessionSubmit>> submitSession(int sessionId) async {
    final response = await _api.post(
      'exams/sessions/$sessionId/submit',
      converter: SessionSubmit.converter,
    );
    if (response.statusCode == 409) throw ExamAlreadySubmittedException();
    if (response.statusCode == 400 || response.statusCode == 403) {
      throw ExamUnavailableException();
    }
    if (!response.isSuccess) throw ExamRequestException();
    return response;
  }

  Future<WrResponse<ExamHistoryResponse>> getHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _api.get(
      'exams/history',
      converter: ExamHistoryResponse.converter,
      queryParameters: {'page': page, 'page_size': pageSize},
    );
    if (!response.isSuccess) throw ExamRequestException();
    return response;
  }
}
