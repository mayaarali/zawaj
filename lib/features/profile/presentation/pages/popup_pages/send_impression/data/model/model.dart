class AppFeedback {
  final String message;

  AppFeedback({required this.message});

  Map<String, dynamic> toJson() => {
        'Message': message,
      };
}
