import 'package:equatable/equatable.dart';
import '../data/farmland.dart';

sealed class FarmlandState extends Equatable {
  const FarmlandState();
  @override
  List<Object?> get props => [];
}

class FarmlandLoading extends FarmlandState {
  const FarmlandLoading();
}

class FarmlandLoaded extends FarmlandState {
  const FarmlandLoaded(this.farmlands);
  final List<Farmland> farmlands;
  @override
  List<Object?> get props => [farmlands];
}

class FarmlandFailure extends FarmlandState {
  const FarmlandFailure();
}
