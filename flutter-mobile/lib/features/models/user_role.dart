enum UserRole {
  athlete,
  coach;

  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'athlete':
        return UserRole.athlete;
      case 'coach':
        return UserRole.coach;
      default:
        throw ArgumentError('Invalid user role :$value');
    }
  }

  String get value {
    switch (this) {
      case UserRole.athlete:
        return 'athlete';
      case UserRole.coach:
        return 'coach';
    }
  }
}
