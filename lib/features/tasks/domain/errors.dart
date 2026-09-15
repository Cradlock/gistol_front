import 'package:app_front/core/errors/domain.dart';
import 'package:app_front/core/strings.dart';

class TaskRequestException extends AppException {
  TaskRequestException()
    : super(
        displayType: ExceptDisplayType.toast,
        localKey: AppStrings.tasks.requestError,
      );
}

class TaskAlreadyAnsweredException extends AppException {
  TaskAlreadyAnsweredException()
    : super(
        displayType: ExceptDisplayType.toast,
        localKey: AppStrings.tasks.alreadyAnswered,
      );
}

class TaskUnavailableException extends AppException {
  TaskUnavailableException()
    : super(
        displayType: ExceptDisplayType.toast,
        localKey: AppStrings.tasks.unavailable,
      );
}
