import 'package:equatable/equatable.dart';

import '../models/livre.dart';

abstract class LivreState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LivreInitial extends LivreState {}

class LivreLoading extends LivreState {}

class LivreLoaded extends LivreState {
  final List<Livre> livres;

  LivreLoaded(this.livres);

  @override
  List<Object?> get props => [livres];
}

class LivreError extends LivreState {
  final String message;

  LivreError(this.message);

  @override
  List<Object?> get props => [message];
}