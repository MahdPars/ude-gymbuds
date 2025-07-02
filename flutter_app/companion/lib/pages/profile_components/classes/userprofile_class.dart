class UserProfile {
  final String username;
  final String email;
  final String name;
  final String profilePicture;
  final int bodyType;
  final int age;
  final double height;
  final double weight;
  final int experience;
  final int goal;
  final int frequency;
  final int workoutsCompleted;
  final int loggingStreak;
  final Map<String, double> measurements;

  UserProfile({
    required this.username,
    required this.email,
    required this.name,
    required this.profilePicture,
    required this.bodyType,
    required this.age,
    required this.height,
    required this.weight,
    required this.experience,
    required this.goal,
    required this.frequency,
    this.workoutsCompleted = 0,
    this.loggingStreak = 0,
    this.measurements = const {
      'Chest': 0.0,
      'Left Arm': 0.0,
      'Right Arm': 0.0,
      'Waist': 0.0,
      'Left Thigh': 0.0,
      'Right Thigh': 0.0,
    },
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      profilePicture: json['profile_picture'] as String? ?? '',
      bodyType: json['bodyType'] as int? ?? 0,
      age: json['age'] as int? ?? 0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      experience: json['experience'] as int? ?? 0,
      goal: json['goal'] as int? ?? 0,
      frequency: json['frequency'] as int? ?? 0,
      workoutsCompleted: json['workouts_completed'] as int? ?? 0,
      loggingStreak: json['logging_streak'] as int? ?? 0,
      measurements: (json['measurements'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, (value as num).toDouble()),
          ) ??
          {
            'Chest': 0.0,
            'Left Arm': 0.0,
            'Right Arm': 0.0,
            'Waist': 0.0,
            'Left Thigh': 0.0,
            'Right Thigh': 0.0,
          },
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'name': name,
      'profile_picture': profilePicture,
      'bodyType': bodyType,
      'age': age,
      'height': height,
      'weight': weight,
      'experience': experience,
      'goal': goal,
      'frequency': frequency,
      'workouts_completed': workoutsCompleted,
      'logging_streak': loggingStreak,
      'measurements': measurements,
    };
  }
}
