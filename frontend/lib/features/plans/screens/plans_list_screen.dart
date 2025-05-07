import 'package:flutter/material.dart';
import 'package:frontend/features/plans/services/plan_service.dart';
import 'package:frontend/features/plans/widgets/plan_card.dart';

class PlansListScreen extends StatefulWidget {
  const PlansListScreen({Key? key}) : super(key: key);

  @override
  _PlansListScreenState createState() =>
      _PlansListScreenState();
}

class _PlansListScreenState extends State<PlansListScreen> {
  final PlanService planService = PlanService();
  List<Map<String, dynamic>> plans = [];

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    try {
      final fetchedPlans = await planService.getPlans(
        "YOUR_JWT_TOKEN",
      );
      setState(() {
        plans = fetchedPlans;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage =
            "Failed to load plans: ${error.toString()}";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your training plans"),
        backgroundColor: const Color(0xFFFDF6F1),
        centerTitle: true,
        elevation: 0,
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(),
              )
              : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  return PlanCard(
                    planName: plan["name"] ?? "No Name",
                    trainingDays: plan["days"] ?? 0,
                    athletesAssigned: plan["athletes"] ?? 0,
                    onEdit: () {
                      // Handel Edit
                    },
                    onDelete: () {
                      // Handle Delete
                    },
                    onAssign: () {
                      // Handle Assign
                    },
                  );
                },
              ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      backgroundColor: const Color(0xFFFFFFFF),
    );
  }
}
