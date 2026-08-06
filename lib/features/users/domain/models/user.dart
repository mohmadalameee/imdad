import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String username;
  final String fullName;
  final String role;
  final bool isActive;

  const User({
    this.id,
    required this.username,
    required this.fullName,
    required this.role,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, username, fullName, role, isActive];
}
