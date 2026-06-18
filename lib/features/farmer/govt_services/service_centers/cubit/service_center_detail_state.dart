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
  const ServiceCenterDetailLoaded({
    required this.center,
    this.submittingRating = false,
  });

  final ServiceCenter center;

  /// True while a rate / delete request is in flight (disables the dialog button).
  final bool submittingRating;

  ServiceCenterDetailLoaded copyWith({
    ServiceCenter? center,
    bool? submittingRating,
  }) {
    return ServiceCenterDetailLoaded(
      center: center ?? this.center,
      submittingRating: submittingRating ?? this.submittingRating,
    );
  }

  @override
  List<Object?> get props => [center, submittingRating];
}
