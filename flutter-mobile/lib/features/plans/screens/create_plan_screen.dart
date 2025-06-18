import 'package:flutter/material.dart';
import 'package:frontend/features/plans/services/plan_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePlanScreen extends StatefulWidget {
  const CreatePlanScreen({Key? key}) : super(key: key);

  @override
  State<CreatePlanScreen> createState() =>
      _CreatePlanScreenState();
}

class _CreatePlanScreenState
    extends State<CreatePlanScreen> {
  final TextEditingController _nameController =
      TextEditingController();
  final TextEditingController _durationController =
      TextEditingController();
  final TextEditingController _sessionsController =
      TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController();
  bool isLoading = false;

  Future<void> _createPlan() async {
    final name = _nameController.text.trim();
    final duration =
        int.tryParse(_durationController.text.trim()) ?? 0;
    final sessions =
        int.tryParse(_sessionsController.text.trim()) ?? 0;
    final description = _descriptionController.text.trim();

    if (name.isEmpty || duration <= 0 || sessions <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("authToken");

      if (token == null) {
        throw Exception("No token found");
      }

      final planService = PlanService();
      await planService.createPlan({
        "name": name,
        "duration": duration,
        "sessions": sessions,
        "description": description,
      }, token);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Plan created successfully!'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create New Plan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Plan Name",
              ),
            ),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: "Duration (days)",
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _sessionsController,
              decoration: const InputDecoration(
                labelText: "Sessions",
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _createPlan,
              child:
                  isLoading
                      ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                      : const Text("Create Plan"),
            ),
          ],
        ),
      ),
    );
  }
}
