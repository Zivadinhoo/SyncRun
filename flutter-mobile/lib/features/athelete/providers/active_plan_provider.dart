import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider koji čuva ID trenutno aktivnog AssignedPlana.
/// Vraća `null` ako nijedan plan nije aktivan.
final activePlanIdProvider = StateProvider<int?>(
  (ref) => null,
);

/// Funkcionalni typedef za setovanje aktivnog plana
typedef SetActivePlan = void Function(int planId);

/// Provider koji daje funkciju za postavljanje aktivnog plana
final setActivePlanProvider = Provider<SetActivePlan>((
  ref,
) {
  return (int planId) {
    ref.read(activePlanIdProvider.notifier).state = planId;
  };
});
