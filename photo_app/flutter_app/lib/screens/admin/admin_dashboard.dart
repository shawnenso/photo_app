import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),

      body: GridView.count(
        crossAxisCount: 2,

        padding: const EdgeInsets.all(20),

        children: [
          dashboardCard("Users"),
          dashboardCard("Albums"),
          dashboardCard("Photos"),
          dashboardCard("Analytics"),
        ],
      ),
    );
  }

  Widget dashboardCard(String title) {
    return Card(
      elevation: 4,

      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
