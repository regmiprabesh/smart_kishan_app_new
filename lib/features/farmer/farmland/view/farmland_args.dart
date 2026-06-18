import '../cubit/farmland_cubit.dart';
import '../data/farmland.dart';

/// Args to the add/edit farmland screen: shared cubit + optional farmland
/// (null = create).
class FarmlandArgs {
  const FarmlandArgs({required this.cubit, this.farmland});
  final FarmlandCubit cubit;
  final Farmland? farmland;
}
