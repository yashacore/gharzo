import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/providers/project_provider.dart';
import 'package:gharzo_project/screens/projects/project_card.dart';
import 'package:gharzo_project/screens/projects/my_enquiries_screen.dart';
import 'package:provider/provider.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  int selectedIndex = 0; // 0 = Projects, 1 = My Enquiries

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProjectProvider>().fetchProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();

    return Scaffold(
      appBar: CommonWidget.gradientAppBar(
        title: "Explore",
        onPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          /// 🔥 TOP TOGGLE
          _topToggle(),

          const SizedBox(height: 12),

          /// 🔽 CONTENT
          Expanded(
            child: selectedIndex == 0
                ? _projectsView(provider)
                : const MyEnquiriesScreen(),
          ),
        ],
      ),
    );
  }

  // ================= TOGGLE =================

  Widget _topToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            _toggleItem("Projects", 0),
            _toggleItem("My Enquiries", 1),
          ],
        ),
      ),
    );
  }

  Widget _toggleItem(String title, int index) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedIndex = index);

          if (index == 1) {
            context.read<ProjectProvider>().fetchMyEnquiries();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: isSelected
                ? [
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              )
            ]
                : [],
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.black : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  // ================= PROJECT LIST =================

  Widget _projectsView(ProjectProvider provider) {
    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error.isNotEmpty) {
      return Center(child: Text(provider.error));
    }

    if (provider.projects.isEmpty) {
      return const Center(child: Text("No projects found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.projects.length,
      itemBuilder: (_, i) =>
          ProjectCard(project: provider.projects[i]),
    );
  }
}