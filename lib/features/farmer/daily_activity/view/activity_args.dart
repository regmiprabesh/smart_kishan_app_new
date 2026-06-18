import 'package:smart_kishan/features/farmer/daily_activity/cubit/daily_activity_cubit.dart';
import 'package:smart_kishan/features/farmer/daily_activity/data/activity.dart';

class ActivityArgs {
  const ActivityArgs({required this.cubit, this.activity});
  final DailyActivityCubit cubit;
  final Activity? activity;
}
