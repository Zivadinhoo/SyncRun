import 'package:flutter/material.dart';
import 'package:frontend/features/plans/services/plan_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlanDetailsScreen extends StatefulWidget {
  final String planId;

  const PlanDetailsScreen({Key? key, required this.planId})
    : super(key: key);

  @override
  State<PlanDetailsScreen> createState() =>
      _PlanDetailsScreenState();
}

class _PlanDetailsScreenState
    extends State<PlanDetailsScreen> {
  Map<String, dynamic>? plan;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadPlanDetails();
  }

  Future<void> loadPlanDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("authToken");

      if (token == null) {
        throw Exception("No token found");
      }

      final planService = PlanService();
      final fetchedPlan = await planService.getPlanById(
        widget.planId,
        token,
      );

      setState(() {
        plan = fetchedPlan;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Plan Details")),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(),
              )
              : errorMessage != null
              ? Center(
                child: Text(
                  "Error: $errorMessage",
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan?["name"] ?? "Unnamed Plan",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Duration: ${plan?["duration"] ?? 0} days",
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Sessions: ${plan?["sessions"] ?? 0}",
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Description: ${plan?["description"] ?? "No description"}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
    );
  }
}
