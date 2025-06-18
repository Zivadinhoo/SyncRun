import 'package:flutter/material.dart';
import 'package:frontend/features/plans/screens/plans_list_screen.dart';
import 'package:frontend/features/plans/services/plan_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoachDashboardScreen extends StatefulWidget {
  const CoachDashboardScreen({Key? key}) : super(key: key);

  @override
  State<CoachDashboardScreen> createState() =>
      _CoachDashboardState();
}

class _CoachDashboardState
    extends State<CoachDashboardScreen> {
  List<Map<String, dynamic>> plans = [];
  bool isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    loadPlans();
  }

  Future<void> loadPlans() async {
    try {
      setState(() => isLoading = true);

      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString("authToken");

      if (token == null) {
        throw Exception("No token found");
      }

      final planService = PlanService();
      final fetchedPlans = await planService.getPlans(
        token!,
      );
      setState(() => plans = fetchedPlans);
    } catch (e) {
      print("Error loading plans: $e");
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Error"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed:
                      () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coach Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadPlans,
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(),
              )
              : plans.isEmpty
              ? const Center(
                child: Text("No plans available"),
              )
              : ListView.builder(
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  final planName =
                      plan["name"] ?? "Unnamed Plan";
                  final duration = plan["duration"] ?? 0;
                  final sessions = plan["sessions"] ?? 0;

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(planName),
                      subtitle: Text(
                        "$duration days | $sessions sessions",
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    PlansListScreen(),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-plan');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
