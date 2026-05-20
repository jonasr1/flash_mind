import 'package:flash_mind/core/progress/controllers/user_progress_controller.dart';
import 'package:flash_mind/core/review/review_service.dart';
import 'package:flutter/widgets.dart';

class AppScope extends InheritedWidget {
  final UserProgressController userProgressController;
  final ReviewService reviewService;

  const AppScope({
    super.key,
    required this.userProgressController,
    required this.reviewService,
    required super.child,
  });

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) {
    return userProgressController != oldWidget.userProgressController ||
        reviewService != oldWidget.reviewService;
  }
}

