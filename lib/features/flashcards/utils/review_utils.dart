String formatNextReview(DateTime nextReviewAt) {
  final now = DateTime.now();
  final difference = nextReviewAt.difference(now);

  final minutes = (difference.inSeconds / 60).ceil();
  if (minutes < 60) {
    if (minutes <= 1) return 'em 1 minuto';
    return 'em $minutes minutos';
  }

  final hours = (minutes / 60).ceil();
  if (hours < 24) {
    if (hours <= 1) return 'em 1 hora';
    return 'em $hours horas';
  }

  final days = (hours / 24).ceil();
  if (days <= 1) return 'amanhã';
  return 'em $days dias';
}
