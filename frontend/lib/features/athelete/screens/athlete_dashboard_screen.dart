import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/assigned_plans_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AthleteDashboardScreen
    extends ConsumerStatefulWidget {
  const AthleteDashboardScreen({super.key});

  @override
  ConsumerState<AthleteDashboardScreen> createState() =>
      _AthleteDashboardScreenState();
}

class _AthleteDashboardScreenState
    extends ConsumerState<AthleteDashboardScreen> {
  final _storage = const FlutterSecureStorage();
  String fullName = '';

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final name = await _storage.read(key: 'fullName');
    setState(() {
      fullName = name ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final assignedPlansAsync = ref.watch(
      assignedPlansFutureProvider,
    );

    return SafeArea(
      child: Column(
        children: [
          Container(
            color: const Color(0xFFFDF6F1),
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            alignment: Alignment.center,
            child: Text(
              fullName.isNotEmpty
                  ? 'Welcome $fullName'
                  : 'Welcome',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: assignedPlansAsync.when(
              data: (plans) {
                final validPlans =
                    plans
                        .where(
                          (p) => p.trainingPlan != null,
                        )
                        .toList();

                if (validPlans.isEmpty) {
                  return const Center(
                    child: Text(
                      'No assigned training plans yet.',
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: validPlans.length,
                  itemBuilder: (context, index) {
                    final plan = validPlans[index];
                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                      ),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          plan.trainingPlan.name ??
                              'No title',
                        ),
                        subtitle: Text(
                          plan.trainingPlan.description ??
                              'No description',
                        ),
                        trailing: Icon(
                          plan.isCompleted
                              ? Icons.check_circle
                              : Icons.schedule,
                          color:
                              plan.isCompleted
                                  ? Colors.green
                                  : Colors.orange,
                        ),
                      ),
                    );
                  },
                );
              },
              loading:
                  () => const Center(
                    child: CircularProgressIndicator(),
                  ),
              error:
                  (err, _) =>
                      Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
