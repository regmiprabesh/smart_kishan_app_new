import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the selected bottom-nav tab for any dashboard. One tiny cubit
/// reused by farmer/marketplace/vendor shells instead of three controllers.
class DashboardTabCubit extends Cubit<int> {
  DashboardTabCubit() : super(0);
  void select(int index) => emit(index);
}
