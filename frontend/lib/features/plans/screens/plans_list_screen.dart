import 'package:flutter/material.dart';
import 'package:frontend/features/plans/screens/plan_detail_screen.dart';
import 'package:frontend/features/plans/services/plan_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlansListScreen extends StatefulWidget {
  const PlansListScreen({Key? key}) : super(key: key);

  @override
  State<PlansListScreen> createState() =>
      _PlansListScreenState();
}

class _PlansListScreenState extends State<PlansListScreen> {
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
        title: const Text("Plans List"),
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
                  final planId = plan["id"] ?? "";
                  final planName =
                      plan["name"] ?? "Unnamed Plan";

                  return ListTile(
                    title: Text(planName),
                    subtitle: Text(
                      "${plan["duration"] ?? 0} days | ${plan["sessions"] ?? 0} sessions",
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  PlanDetailsScreen(
                                    planId: planId,
                                  ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
