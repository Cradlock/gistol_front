import 'package:app_front/core/errors/domain.dart';
import 'package:app_front/core/strings.dart';

class ExamRequestException extends AppException {
  ExamRequestException()
    : super(
        displayType: ExceptDisplayType.toast,
        localKey: AppStrings.exams.requestError,
      );
}

class ExamAlreadySubmittedException extends AppException {
  ExamAlreadySubmittedException()
    : super(
        displayType: ExceptDisplayType.toast,
        localKey: AppStrings.exams.alreadySubmitted,
      );
}

class ExamUnavailableException extends AppException {
  ExamUnavailableException()
    : super(
        displayType: ExceptDisplayType.toast,
        localKey: AppStrings.exams.unavailable,
      );
}
