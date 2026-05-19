enum ReviewRating { forgot, difficult, easy }

extension ReviewRatingLabel on ReviewRating {
  String get label {
    switch (this) {
      case ReviewRating.forgot:
        return 'Não sabia';
      case ReviewRating.difficult:
        return 'Difícil';
      case ReviewRating.easy:
        return 'Fácil';
    }
  }
}
