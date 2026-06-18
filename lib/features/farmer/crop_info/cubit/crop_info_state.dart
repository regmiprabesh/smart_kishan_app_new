import 'package:equatable/equatable.dart';
import '../data/crop_info.dart';

sealed class CropInfoState extends Equatable {
  const CropInfoState();
  @override
  List<Object?> get props => [];
}

class CropInfoLoading extends CropInfoState {
  const CropInfoLoading();
}

class CropInfoLoaded extends CropInfoState {
  const CropInfoLoaded({required this.crops, this.query = ''});
  final List<CropInfo> crops;
  final String query;

  CropInfoLoaded copyWith({List<CropInfo>? crops, String? query}) =>
      CropInfoLoaded(crops: crops ?? this.crops, query: query ?? this.query);

  @override
  List<Object?> get props => [crops, query];
}

class CropInfoFailure extends CropInfoState {
  const CropInfoFailure();
}
