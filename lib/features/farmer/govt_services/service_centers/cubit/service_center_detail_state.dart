import 'package:equatable/equatable.dart';

import '../data/service_center.dart';

sealed class ServiceCenterDetailState extends Equatable {
  const ServiceCenterDetailState();
  @override
  List<Object?> get props => [];
}

class ServiceCenterDetailLoading extends ServiceCenterDetailState {
  const ServiceCenterDetailLoading();
}

class ServiceCenterDetailFailure extends ServiceCenterDetailState {
  const ServiceCenterDetailFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class ServiceCenterDetailLoaded extends ServiceCenterDetailState {
  const ServiceCenterDetailLoaded({required this.center});

  final ServiceCenter center;

  @override
  List<Object?> get props => [center];
}
