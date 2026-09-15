import 'package:flutter/material.dart';
import 'package:app_front/features/exams/domain/errors.dart';
import 'package:app_front/features/exams/domain/exam.dart';
import 'package:app_front/features/exams/services/exams_service.dart';

class ExamsProvider extends ChangeNotifier {
  final ExamsService _service = ExamsService();

  static const int pageSize = 20;

  List<ExamSummary> exams = [];
  List<ExamHistoryItem> history = [];
  SessionTake? currentTake;

  bool isExamsLoading = false;
  bool isOpening = false;
  bool isSaving = false;
  bool isSubmitting = false;
  bool isHistoryLoading = false;
  bool hasMoreExams = true;
  bool hasMoreHistory = true;

  int _examsPage = 1;
  int _historyPage = 1;

  Future<void> fetchExams({bool refresh = false}) async {
    if (isExamsLoading || (!refresh && !hasMoreExams)) return;
    if (refresh) {
      _examsPage = 1;
      hasMoreExams = true;
    }

    isExamsLoading = true;
    notifyListeners();
    try {
      final response = await _service.getAvailable(
        page: _examsPage,
        pageSize: pageSize,
      );
      final data = response.data!;
      exams = refresh ? data.exams : [...exams, ...data.exams];
      hasMoreExams = exams.length < data.total;
      if (hasMoreExams) _examsPage++;
    } finally {
      isExamsLoading = false;
      notifyListeners();
    }
  }

  Future<SessionTake> openExam(ExamSummary exam) async {
    if (isOpening) {
      final current = currentTake;
      if (current != null && current.examId == exam.id) return current;
    }

    isOpening = true;
    notifyListeners();
    try {
      final started = (await _service.startExam(exam.id)).data!;
      final take = (await _service.takeSession(started.id)).data!;
      currentTake = take;
      return take;
    } on ExamAlreadySubmittedException {
      exams.removeWhere((item) => item.id == exam.id);
      rethrow;
    } finally {
      isOpening = false;
      notifyListeners();
    }
  }

  Future<void> saveAnswer(int questionId, AnswerUpsertRequest data) async {
    final take = currentTake;
    if (take == null || isSubmitting) return;
    isSaving = true;
    notifyListeners();
    try {
      await _service.saveAnswer(take.id, questionId, data);
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> submitExam() async {
    final take = currentTake;
    if (take == null || isSubmitting) return;
    isSubmitting = true;
    notifyListeners();
    try {
      await _service.submitSession(take.id);
      exams.removeWhere((item) => item.id == take.examId);
      currentTake = null;
      history = [];
      _historyPage = 1;
      hasMoreHistory = true;
    } on ExamAlreadySubmittedException {
      exams.removeWhere((item) => item.id == take.examId);
      currentTake = null;
      rethrow;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> fetchHistory({bool refresh = false}) async {
    if (isHistoryLoading || (!refresh && !hasMoreHistory)) return;
    if (refresh) {
      _historyPage = 1;
      hasMoreHistory = true;
    }

    isHistoryLoading = true;
    notifyListeners();
    try {
      final response = await _service.getHistory(
        page: _historyPage,
        pageSize: pageSize,
      );
      final data = response.data!;
      history = refresh ? data.sessions : [...history, ...data.sessions];
      hasMoreHistory = history.length < data.total;
      if (hasMoreHistory) _historyPage++;
    } finally {
      isHistoryLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreExams(ScrollController controller) async {
    if (!controller.hasClients || !hasMoreExams || isExamsLoading) return;
    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 120) {
      await fetchExams();
    }
  }

  Future<void> loadMoreHistory(ScrollController controller) async {
    if (!controller.hasClients || !hasMoreHistory || isHistoryLoading) return;
    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 120) {
      await fetchHistory();
    }
  }
}
